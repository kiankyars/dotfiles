---
name: edit-iphone-timelapse
description: Create a caption-free 60-second edit from relevant iPhone videos in Apple Photos, including ordinary recordings accidentally made instead of Time-lapse, with Minecraft music and exact-source cleanup.
---

# Edit iPhone Timelapses

## Output

- Default to exactly 60.000 seconds, 1920x1080, 60 fps/3,600 frames, H.264/yuv420p with stereo AAC.
- Put the represented human duration in the filename and summary, never in the video frames.
- Use the shell for `osxphotos`, `ffprobe`, and FFmpeg; use app control only for Photos.

## Workflow

1. Wait for import or iCloud sync to settle. Search every movie in the requested local-time window—not only the **Time-lapse** album—and reconcile the count with the user. Lock each source's UUID and identifying metadata.
2. Export the locked UUIDs together into disposable temporary space. Remove temporary exports on every exit path; never retain them as backups.
3. Derive represented wall-clock intervals cautiously from Photos and QuickTime metadata. For an ordinary video, use its verified start plus encoded duration. Merge overlaps, exclude gaps, and ask rather than guess when timing conflicts.
4. Allocate 3,600 frames chronologically and in proportion to represented time. Render from the originals and prefer distinct frames; never fake 60 fps by duplicating a completed 30 fps edit. Interpolate only when necessary and visually sound. Convert HDR or Dolby Vision accurately to BT.709 SDR.
5. Add a fresh natural-speed 60-second segment of `~/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/Minecraft.mp3` with a short fade-out. Write the candidate to `~/Downloads` under a unique filename; never overwrite an existing export.
6. Before replacement or cleanup, verify duration, frame rate/count, streams, full decode, audio, metadata, source coverage, and transitions.
7. Explicit invocation includes moving locked sources to Recently Deleted unless the user opts out. Delete only exact UUID matches; verify each is absent from the active library and present in Recently Deleted. If identity or verification is uncertain, leave Photos untouched and report it.
