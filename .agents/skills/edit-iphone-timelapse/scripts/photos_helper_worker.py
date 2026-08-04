#!/usr/bin/env python3
"""Run Timelapse Photos Helper requests outside the ChatGPT process tree."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

HELPER = (
    Path.home()
    / "Applications"
    / "Timelapse Photos Helper.app"
    / "Contents"
    / "MacOS"
    / "timelapse-photos-helper"
)
REQUEST = (
    Path.home()
    / "Library"
    / "Application Support"
    / "Timelapse Photos Helper"
    / "request.json"
)
RESPONSE = REQUEST.with_name("response.json")


def write_response(payload: dict[str, object]) -> None:
    temporary = RESPONSE.with_suffix(".tmp")
    temporary.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    temporary.replace(RESPONSE)


def main() -> int:
    if not REQUEST.is_file():
        return 0

    try:
        payload = json.loads(REQUEST.read_text())
    except (OSError, json.JSONDecodeError) as error:
        REQUEST.unlink(missing_ok=True)
        write_response({"error": f"Invalid helper request: {error}", "exit_code": 2})
        return 2

    REQUEST.unlink(missing_ok=True)
    action = payload.get("action")
    if action == "authorization":
        command = [str(HELPER), "--request-authorization"]
    elif action == "delete":
        command = [str(HELPER), "--confirm-delete"]
        uuids = payload.get("uuids")
        if not isinstance(uuids, list) or not uuids:
            write_response({"error": "Deletion request has no UUIDs", "exit_code": 2})
            return 2
        for uuid in uuids:
            command.extend(["--uuid", str(uuid)])
    else:
        write_response({"error": f"Unknown helper action: {action}", "exit_code": 2})
        return 2

    result = subprocess.run(command, capture_output=True, text=True, check=False)
    output = result.stdout.strip() or result.stderr.strip()
    try:
        response = json.loads(output)
    except json.JSONDecodeError:
        response = {"error": output or "Timelapse Photos Helper returned no output"}
    response["exit_code"] = result.returncode
    write_response(response)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
