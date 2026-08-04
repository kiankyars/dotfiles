---
name: edit-iphone-timelapse
description: Turn iPhone Time-lapse videos in Apple Photos into a finished video in Downloads using OSXPhotos, FFmpeg, timeline-derived human duration, and Minecraft music, then remove the source clips from Photos. Use when the user explicitly asks to run the personal time-lapse workflow.
---

# Edit iPhone Timelapses

Make the video entirely through CLI tools. Exercise editorial judgment; this is not a fixed editing recipe.

1. Find the intended Time-lapse clips with `osxphotos`, retain their UUIDs, and export them without changing Photos.
2. Read each MOV with `ffprobe`. Treat `com.apple.quicktime.creationdate` as its real start and `creation_time` as its real end. Merge overlapping or touching intervals, then sum the merged intervals for the human-time label; do not count gaps between sessions.
3. Choose a final duration of at most roughly 60-90 seconds. Give each clip a share proportional to the real time it represents: `clip output duration = final duration × clip real duration / sum of all clip real durations`. Retime clips independently with `ffmpeg`, then combine them chronologically. Never weight clips by their Apple-encoded durations.
4. Add a simple visible human-time label and Minecraft music. Do not lengthen short footage merely to reach the target range.
5. Save the final MP4 to `~/Downloads` and verify it with `ffprobe` and a full decode.
6. Only after verification succeeds, delete the exact source UUIDs from Photos with `uv run scripts/delete_photos_assets.py --uuid UUID ... --confirm-delete`, verify the reported count, and remove the staging exports. If deletion fails, retain the exports and report the failure.

## Minecraft music

Use the newest JSON index in `~/Library/Application Support/minecraft/assets/indexes/`. Its `minecraft/sounds/music/` entries map logical track names to hashes stored at `assets/objects/<first two hash characters>/<hash>`. The files are Ogg audio and FFmpeg can read them directly.

Choose a fitting track and a fresh valid starting offset each run so the music slice varies. Do not add tracking metadata or sidecar files.

Do not analyze the frames, create X post copy or bullet points, interact with X, or import the result into Photos.
