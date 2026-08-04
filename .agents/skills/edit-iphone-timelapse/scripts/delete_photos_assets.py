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
import sys

import Photos


def bare_uuid(identifier: str) -> str:
    return identifier.split("/", 1)[0].upper()


def delete_assets(uuids: list[str]) -> dict[str, object]:
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

    success, error = Photos.PHPhotoLibrary.sharedPhotoLibrary().performChangesAndWait_error_(
        changes, None
    )
    if not success:
        raise RuntimeError(f"PhotoKit deletion failed: {error}")

    return {"deleted": len(assets), "uuids": requested}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uuid", action="append", required=True)
    parser.add_argument("--confirm-delete", action="store_true")
    args = parser.parse_args()

    if not args.confirm_delete:
        print(json.dumps({"deleted": 0, "dry_run": True, "uuids": args.uuid}, indent=2))
        return 2

    try:
        print(json.dumps(delete_assets(args.uuid), indent=2))
        return 0
    except Exception as error:
        print(json.dumps({"error": str(error)}, indent=2), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
