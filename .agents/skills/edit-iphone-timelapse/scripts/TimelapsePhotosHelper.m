#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

static NSString *const HelperIdentifier = @"com.kiankyars.timelapse-photos-helper";

static void Emit(NSDictionary *payload, NSFileHandle *handle) {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:payload
                                                   options:NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys
                                                     error:&error];
    if (data == nil) {
        data = [[NSString stringWithFormat:@"{\"error\":\"%@\"}\n", error.localizedDescription]
            dataUsingEncoding:NSUTF8StringEncoding];
    }
    [handle writeData:data];
    [handle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

static NSString *StatusName(PHAuthorizationStatus status) {
    switch (status) {
        case PHAuthorizationStatusNotDetermined: return @"not-determined";
        case PHAuthorizationStatusRestricted: return @"restricted";
        case PHAuthorizationStatusDenied: return @"denied";
        case PHAuthorizationStatusAuthorized: return @"authorized";
        case PHAuthorizationStatusLimited: return @"limited";
    }
    return @"unknown";
}

static void WaitForSemaphore(dispatch_semaphore_t semaphore) {
    while (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC)) != 0) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    }
}

static PHAuthorizationStatus RequestAuthorization(void) {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    if (status != PHAuthorizationStatusNotDetermined) {
        return status;
    }

    __block PHAuthorizationStatus result = status;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite
                                               handler:^(PHAuthorizationStatus requestedStatus) {
        result = requestedStatus;
        dispatch_semaphore_signal(semaphore);
    }];
    WaitForSemaphore(semaphore);
    return result;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSArray<NSString *> *arguments = [NSProcessInfo processInfo].arguments;
        NSMutableArray<NSString *> *identifiers = [NSMutableArray array];
        BOOL confirmDelete = NO;
        BOOL requestAccess = NO;

        for (NSUInteger index = 1; index < arguments.count; index++) {
            NSString *argument = arguments[index];
            if ([argument isEqualToString:@"--uuid"]) {
                if (index + 1 >= arguments.count) {
                    Emit(@{@"error": @"--uuid requires a value"}, [NSFileHandle fileHandleWithStandardError]);
                    return 2;
                }
                [identifiers addObject:[arguments[++index] uppercaseString]];
            } else if ([argument isEqualToString:@"--confirm-delete"]) {
                confirmDelete = YES;
            } else if ([argument isEqualToString:@"--request-authorization"]) {
                requestAccess = YES;
            } else {
                Emit(@{@"error": [NSString stringWithFormat:@"Unknown argument: %@", argument]},
                     [NSFileHandle fileHandleWithStandardError]);
                return 2;
            }
        }

        NSApplication *application = [NSApplication sharedApplication];
        [application setActivationPolicy:NSApplicationActivationPolicyAccessory];

        if (requestAccess) {
            PHAuthorizationStatus status = RequestAuthorization();
            Emit(@{@"authorization_status": StatusName(status), @"helper": HelperIdentifier},
                 [NSFileHandle fileHandleWithStandardOutput]);
            return status == PHAuthorizationStatusAuthorized ? 0 : 1;
        }

        if (identifiers.count == 0) {
            Emit(@{@"error": @"At least one --uuid is required"}, [NSFileHandle fileHandleWithStandardError]);
            return 2;
        }
        if (!confirmDelete) {
            Emit(@{@"error": @"Deletion requires --confirm-delete"}, [NSFileHandle fileHandleWithStandardError]);
            return 2;
        }

        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        if (status != PHAuthorizationStatusAuthorized) {
            Emit(@{
                @"authorization_status": StatusName(status),
                @"error": @"Photos read/write access is not authorized for Timelapse Photos Helper",
            }, [NSFileHandle fileHandleWithStandardError]);
            return 1;
        }

        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:identifiers options:nil];
        NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
        NSMutableSet<NSString *> *found = [NSMutableSet set];
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger index, BOOL *stop) {
            [assets addObject:asset];
            NSString *bareIdentifier = [[[asset.localIdentifier componentsSeparatedByString:@"/"] firstObject]
                uppercaseString];
            [found addObject:bareIdentifier];
        }];

        NSMutableArray<NSString *> *missing = [NSMutableArray array];
        for (NSString *identifier in identifiers) {
            NSString *bareIdentifier = [[identifier componentsSeparatedByString:@"/"] firstObject];
            if (![found containsObject:bareIdentifier]) {
                [missing addObject:identifier];
            }
        }
        if (missing.count > 0) {
            Emit(@{@"error": @"Photos assets not found", @"missing_uuids": missing},
                 [NSFileHandle fileHandleWithStandardError]);
            return 1;
        }

        __block BOOL deletionSucceeded = NO;
        __block NSError *deletionError = nil;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:assets];
        } completionHandler:^(BOOL success, NSError *error) {
            deletionSucceeded = success;
            deletionError = error;
            dispatch_semaphore_signal(semaphore);
        }];
        WaitForSemaphore(semaphore);

        if (!deletionSucceeded) {
            Emit(@{@"error": deletionError.localizedDescription ?: @"PhotoKit deletion failed"},
                 [NSFileHandle fileHandleWithStandardError]);
            return 1;
        }

        Emit(@{@"deleted": @(assets.count), @"uuids": identifiers}, [NSFileHandle fileHandleWithStandardOutput]);
        return 0;
    }
}
