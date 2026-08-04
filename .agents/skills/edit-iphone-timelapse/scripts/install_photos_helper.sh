#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${HOME}/Applications/Timelapse Photos Helper.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
EXECUTABLE="$MACOS_DIR/timelapse-photos-helper"
REQUEST_DIR="${HOME}/Library/Application Support/Timelapse Photos Helper"
REQUEST_PATH="$REQUEST_DIR/request.json"
LAUNCH_AGENT="${HOME}/Library/LaunchAgents/com.kiankyars.timelapse-photos-helper.plist"
LAUNCH_LABEL="com.kiankyars.timelapse-photos-helper"

mkdir -p "$MACOS_DIR" "$REQUEST_DIR" "${HOME}/Library/LaunchAgents"
cp "$SCRIPT_DIR/TimelapsePhotosHelper-Info.plist" "$CONTENTS_DIR/Info.plist"
xcrun clang \
    -O \
    -fobjc-arc \
    -framework AppKit \
    -framework Foundation \
    -framework Photos \
    "$SCRIPT_DIR/TimelapsePhotosHelper.m" \
    -o "$EXECUTABLE"
codesign --force --sign - --identifier com.kiankyars.timelapse-photos-helper "$APP_DIR"
codesign --verify --strict "$APP_DIR"

cp "$SCRIPT_DIR/com.kiankyars.timelapse-photos-helper.plist.template" "$LAUNCH_AGENT"
plutil -replace ProgramArguments.1 -string "$SCRIPT_DIR/photos_helper_worker.py" "$LAUNCH_AGENT"
plutil -remove ProgramArguments.2 "$LAUNCH_AGENT"
plutil -replace WatchPaths.0 -string "$REQUEST_PATH" "$LAUNCH_AGENT"
plutil -remove WatchPaths.1 "$LAUNCH_AGENT"
plutil -replace StandardOutPath -string "$REQUEST_DIR/worker.stdout.log" "$LAUNCH_AGENT"
plutil -replace StandardErrorPath -string "$REQUEST_DIR/worker.stderr.log" "$LAUNCH_AGENT"
plutil -lint "$LAUNCH_AGENT"

USER_ID="$(id -u)"
launchctl bootout "gui/${USER_ID}" "$LAUNCH_AGENT" >/dev/null 2>&1 || true
launchctl bootstrap "gui/${USER_ID}" "$LAUNCH_AGENT"
launchctl enable "gui/${USER_ID}/${LAUNCH_LABEL}"

echo "Installed $APP_DIR"
echo "Installed and loaded $LAUNCH_LABEL"
echo "Request Photos access with:"
echo "  uv run '$SCRIPT_DIR/delete_photos_assets.py' --request-authorization"
