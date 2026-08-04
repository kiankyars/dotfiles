---
name: edit-iphone-timelapse
description: Turn iPhone Time-lapse videos in Apple Photos into a finished video in Downloads using OSXPhotos, FFmpeg, timeline-derived human duration, and Minecraft music, then remove the source clips from Photos.
---

# Edit iPhone Timelapses

1. Find and export the intended Time-lapse clips with `osxphotos`, retaining their UUIDs.
2. Read each MOV with `ffprobe`, using `com.apple.quicktime.creationdate` as its real start and `creation_time` as its real end. Merge overlapping or touching intervals and sum them for the human-time label; exclude gaps between sessions.
3. Choose a final duration up to roughly 60-90 seconds. Allocate each clip `final duration × clip real duration / sum of all clip real durations`, retime the clips independently with `ffmpeg`, and combine them chronologically.
4. Add the human-time label and Minecraft music. Save the MP4 to `~/Downloads` and verify it with `ffprobe` and a full decode.
5. Delete the source UUIDs with `uv run scripts/delete_photos_assets.py --uuid UUID ... --confirm-delete` and remove the staging exports.

## Minecraft music

Use the newest JSON index in `~/Library/Application Support/minecraft/assets/indexes/`. Resolve `minecraft/sounds/music/` entries to `assets/objects/<first two hash characters>/<hash>`, then choose a track and fresh valid starting offset.
