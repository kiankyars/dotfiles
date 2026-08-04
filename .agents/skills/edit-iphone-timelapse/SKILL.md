---
name: edit-iphone-timelapse
description: Turn one or more iPhone Time-lapse videos in Apple Photos into a finished video in Downloads using OSXPhotos, FFmpeg, timeline-derived human duration, and Minecraft music. Use when the user asks to edit, combine, caption, or export iPhone time-lapse clips for posting.
---

# Edit iPhone Timelapses

Make the video entirely through CLI tools. Exercise editorial judgment; this is not a fixed editing recipe.

1. Find the intended Time-lapse clips with `osxphotos` and export them without changing Photos.
2. Read each exported MOV with `ffprobe`. Treat `com.apple.quicktime.creationdate` as the recording start and `creation_time` as the end; subtract them to get human elapsed time. Combine contiguous clips on their shared timeline, or sum separate sessions. Ask only if the tags are missing or contradictory.
3. Use `ffmpeg` to combine and edit the clips chronologically. Keep the result at most roughly 60-90 seconds; do not lengthen short footage merely to hit that range.
4. Add a simple visible label such as `49-minute time-lapse` using the timeline-derived duration.
5. Add Minecraft music, verify the finished file with `ffprobe` and a full decode, and save only the final MP4 to `~/Downloads`.

## Minecraft music

Use the newest JSON index in `~/Library/Application Support/minecraft/assets/indexes/`. Its `minecraft/sounds/music/` entries map logical track names to hashes stored at `assets/objects/<first two hash characters>/<hash>`. The files are Ogg audio and FFmpeg can read them directly.

Choose a fitting track and a fresh valid starting offset each run so the music slice varies. Do not add tracking metadata or sidecar files.

Do not analyze the frames, create X post copy or bullet points, interact with X, import the result into Photos, or delete anything from Photos.
