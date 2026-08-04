#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "pyobjc-framework-Cocoa>=12.2.1",
#   "pyobjc-framework-Photos>=12.2.1",
# ]
# ///
"""Move explicitly identified Photos assets to Recently Deleted."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys

import Photos


DELETE_DIALOG_CLICKER = r'''
set deadline to (current date) + __TIMEOUT_SECONDS__
tell application "System Events"
    repeat while (current date) is less than deadline
        repeat with appProcess in application processes
            try
                repeat with appWindow in windows of appProcess
                    set sawICloudPhotos to false
                    set sawRecentlyDeleted to false
                    set deleteButton to missing value
                    repeat with uiItem in entire contents of appWindow
                        try
                            set itemRole to role of uiItem
                            if itemRole is "AXStaticText" then
                                set itemValue to value of uiItem as text
                                if itemValue contains "iCloud Photos" then set sawICloudPhotos to true
                                if itemValue contains "Recently Deleted for 30 days" then set sawRecentlyDeleted to true
                            else if itemRole is "AXButton" then
                                if (name of uiItem as text) is "Delete" then set deleteButton to uiItem
                            end if
                        end try
                    end repeat
                    if sawICloudPhotos and sawRecentlyDeleted and deleteButton is not missing value then
                        click deleteButton
                        return "clicked"
                    end if
                end repeat
            end try
        end repeat
        delay 0.1
    end repeat
end tell
return "timeout"
'''


def bare_uuid(identifier: str) -> str:
    return identifier.split("/", 1)[0].upper()


def start_delete_dialog_clicker(timeout_seconds: int = 120) -> subprocess.Popen[str]:
    script = DELETE_DIALOG_CLICKER.replace(
        "__TIMEOUT_SECONDS__", str(timeout_seconds)
    )
    return subprocess.Popen(
        ["osascript", "-e", script],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )


def finish_delete_dialog_clicker(process: subprocess.Popen[str] | None) -> str:
    if process is None:
        return "manual"
    try:
        stdout, stderr = process.communicate(timeout=1)
    except subprocess.TimeoutExpired:
        process.terminate()
        stdout, stderr = process.communicate(timeout=1)
        return "not-observed"
    if process.returncode:
        return f"error: {stderr.strip()}"
    return stdout.strip() or "finished"


def delete_assets(
    uuids: list[str], auto_confirm_dialog: bool = False
) -> dict[str, object]:
    status = Photos.PHPhotoLibrary.authorizationStatusForAccessLevel_(
        Photos.PHAccessLevelReadWrite
    )
    if status != Photos.PHAuthorizationStatusAuthorized:
        raise RuntimeError("Photos read/write access is not authorized")

    requested = list(dict.fromkeys(uuids))
    result = Photos.PHAsset.fetchAssetsWithLocalIdentifiers_options_(requested, None)
    assets = [result.objectAtIndex_(index) for index in range(result.count())]
    found = {bare_uuid(str(asset.localIdentifier())) for asset in assets}
    missing = [uuid for uuid in requested if bare_uuid(uuid) not in found]
    if missing:
        raise RuntimeError(f"Photos assets not found: {', '.join(missing)}")

    def changes() -> None:
        Photos.PHAssetChangeRequest.deleteAssets_(assets)

    clicker = start_delete_dialog_clicker() if auto_confirm_dialog else None
    try:
        success, error = (
            Photos.PHPhotoLibrary.sharedPhotoLibrary().performChangesAndWait_error_(
                changes, None
            )
        )
    finally:
        dialog_confirmation = finish_delete_dialog_clicker(clicker)
    if not success:
        raise RuntimeError(f"PhotoKit deletion failed: {error}")

    return {
        "deleted": len(assets),
        "uuids": requested,
        "dialog_confirmation": dialog_confirmation,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uuid", action="append", required=True)
    parser.add_argument("--confirm-delete", action="store_true")
    parser.add_argument("--auto-confirm-dialog", action="store_true")
    args = parser.parse_args()

    if not args.confirm_delete:
        print(json.dumps({"deleted": 0, "dry_run": True, "uuids": args.uuid}, indent=2))
        return 2

    try:
        print(
            json.dumps(
                delete_assets(args.uuid, args.auto_confirm_dialog), indent=2
            )
        )
        return 0
    except Exception as error:
        print(json.dumps({"error": str(error)}, indent=2), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
