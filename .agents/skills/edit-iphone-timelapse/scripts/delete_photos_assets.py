#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Move explicitly identified Photos assets to Recently Deleted."""

from __future__ import annotations

import argparse
import fcntl
import json
import sys
import time
from pathlib import Path

PHOTOS_HELPER = (
    Path.home()
    / "Applications"
    / "Timelapse Photos Helper.app"
    / "Contents"
    / "MacOS"
    / "timelapse-photos-helper"
)
PHOTOS_HELPER_DIR = (
    Path.home() / "Library" / "Application Support" / "Timelapse Photos Helper"
)
PHOTOS_HELPER_REQUEST = PHOTOS_HELPER_DIR / "request.json"
PHOTOS_HELPER_RESPONSE = PHOTOS_HELPER_DIR / "response.json"
PHOTOS_HELPER_LOCK = PHOTOS_HELPER_DIR / "request.lock"


def delete_assets(uuids: list[str]) -> dict[str, object]:
    requested = list(dict.fromkeys(uuids))
    if not PHOTOS_HELPER.is_file():
        raise RuntimeError(
            "Timelapse Photos Helper is not installed; run "
            "bash /Users/kian/.agents/skills/edit-iphone-timelapse/scripts/"
            "install_photos_helper.sh"
        )

    payload = request_photos_helper({"action": "delete", "uuids": requested})
    if payload.get("exit_code") != 0:
        raise RuntimeError(str(payload.get("error", "Timelapse Photos Helper failed")))

    return payload


def request_photos_helper(
    payload: dict[str, object], timeout_seconds: int = 180
) -> dict[str, object]:
    PHOTOS_HELPER_DIR.mkdir(parents=True, exist_ok=True)
    with PHOTOS_HELPER_LOCK.open("w") as lock_handle:
        fcntl.flock(lock_handle, fcntl.LOCK_EX)
        PHOTOS_HELPER_RESPONSE.unlink(missing_ok=True)
        temporary = PHOTOS_HELPER_REQUEST.with_suffix(".tmp")
        temporary.write_text(json.dumps(payload, sort_keys=True) + "\n")
        temporary.replace(PHOTOS_HELPER_REQUEST)

        deadline = time.monotonic() + timeout_seconds
        while time.monotonic() < deadline:
            if PHOTOS_HELPER_RESPONSE.is_file():
                response = json.loads(PHOTOS_HELPER_RESPONSE.read_text())
                PHOTOS_HELPER_RESPONSE.unlink(missing_ok=True)
                if not isinstance(response, dict):
                    raise RuntimeError("Timelapse Photos Helper returned invalid output")
                return response
            time.sleep(0.1)
    raise TimeoutError("Timed out waiting for Timelapse Photos Helper")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uuid", action="append")
    parser.add_argument("--request-authorization", action="store_true")
    parser.add_argument("--confirm-delete", action="store_true")
    args = parser.parse_args()

    if args.request_authorization:
        payload = request_photos_helper({"action": "authorization"})
        print(json.dumps(payload, indent=2))
        return 0 if payload.get("authorization_status") == "authorized" else 1

    if not args.uuid:
        parser.error("--uuid is required unless --request-authorization is used")

    if not args.confirm_delete:
        print(
            json.dumps(
                {
                    "deleted": 0,
                    "error": "Deletion not requested; rerun with --confirm-delete.",
                    "uuids": args.uuid,
                },
                indent=2,
            ),
            file=sys.stderr,
        )
        return 2

    try:
        print(json.dumps(delete_assets(args.uuid), indent=2))
        return 0
    except Exception as error:
        print(json.dumps({"error": str(error)}, indent=2), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
