---
name: edit-iphone-timelapse
description: Turn iPhone Time-lapse videos in Apple Photos into a finished video in Downloads using OSXPhotos, FFmpeg, timeline-derived human duration, and Minecraft music, then remove the source clips from Photos.
---

# Edit iPhone Timelapses

1. Find and export the intended Time-lapse clips with `osxphotos`, retaining their UUIDs.
2. Read each MOV with `ffprobe`. Treat `com.apple.quicktime.creationdate` as a candidate start and `creation_time` as a candidate end only when the end is later and the interval is plausible; copies and exports can rewrite the generic `creation_time`. If the tags are missing or contradictory, use trustworthy Photos timing evidence, ask for the duration, or label it approximate. Merge overlapping or touching intervals and sum them for the human duration; exclude gaps between sessions.
3. Choose a final duration up to roughly 60-90 seconds. Allocate each clip `final duration × clip real duration / sum of all clip real durations`, retime the clips independently with `ffmpeg`, and combine them chronologically.
4. Add a segment of `~/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/Minecraft.mp3`, choosing a fresh valid starting offset. Put the human duration in the filename, never in the video frames. Save the MP4 to `~/Downloads` and verify it with `ffprobe` and a full decode.
5. Delete the source UUIDs with `uv run /Users/kian/.agents/skills/edit-iphone-timelapse/scripts/delete_photos_assets.py --uuid UUID ... --confirm-delete`. While the command waits, use Computer Use on **Timelapse Photos Helper** to inspect the PhotoKit confirmation and click **Delete** only when it is the expected recoverable move to Recently Deleted. Remove the staging exports afterward. If the dedicated helper app is missing, install it once with `bash /Users/kian/.agents/skills/edit-iphone-timelapse/scripts/install_photos_helper.sh`; macOS will require one manual Photos permission grant.
