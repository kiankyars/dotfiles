---
name: edit-iphone-timelapse
description: Turn iPhone Time-lapse videos in Apple Photos into a finished video in Downloads using Computer Use, FFmpeg, timeline-derived human duration, and Minecraft music, then remove the source clips from Photos.
---

# Edit iPhone Timelapses

1. Use Computer Use in Photos under **Media Types → Time-lapse**. Identify the intended clips from their visible date, duration, location, and thumbnail, then export them to a temporary staging directory. Record those same identifying details for cleanup.
2. Read each MOV with `ffprobe`. Treat `com.apple.quicktime.creationdate` as a candidate start and `creation_time` as a candidate end only when the end is later and the interval is plausible; copies and exports can rewrite the generic `creation_time`. If the tags are missing or contradictory, use trustworthy Photos timing evidence, ask for the duration, or label it approximate. Merge overlapping or touching intervals and sum them for the human duration; exclude gaps between sessions.
3. Choose a final duration up to roughly 60-90 seconds. Allocate each clip `final duration × clip real duration / sum of all clip real durations`, retime the clips independently with `ffmpeg`, and combine them chronologically.
4. Add a segment of `~/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/Minecraft.mp3`, choosing a fresh valid starting offset. Put the human duration in the filename, never in the video frames. Save the MP4 to `~/Downloads` and verify it with `ffprobe` and a full decode.
5. After verifying the finished MP4, use Computer Use in Photos to select every exported source clip, press **Delete**, and approve the native confirmation. Do not stop after producing the output. This intentionally moves the sources to Recently Deleted across iCloud Photos devices. Remove the staging exports afterward.
