---
name: edit-iphone-timelapse
description: Create caption-free iPhone timelapse videos from every movie captured on a requested date in Apple Photos, combined chronologically with a local Minecraft or Halo soundtrack and rendered to the requested duration. Use when the user asks to make or process a dated iPhone timelapse.
---

# Edit iPhone Timelapses

1. Resolve the requested local date. Use the duration explicitly provided in the conversation; if none is provided, ask for it before starting.
2. Query every movie in that date window once through background Photos scripting, including ordinary movies recorded instead of Time-lapse. Export the originals together to one temporary directory without opening or activating Photos.
3. Order the clips by capture time and use their full contents as recorded. Derive represented time from their QuickTime start and end times, excluding gaps and merging overlaps, then allocate output frames proportionally. Preserve native pixel orientation when QuickTime display-matrix metadata conflicts; for already-horizontal pixels, disable autorotation with `-noautorotate`. Keep the work limited to combining and retiming the recordings unless the user asks for editorial changes.
4. Choose either `~/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/Minecraft.mp3` or `~/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/Halo.mp3`, use a suitable segment at natural speed, and add a short fade-out.
5. Render one caption-free MP4 in `~/Downloads` named `iPhone Timelapse - YYYY-MM-DD - REPRESENTED - DURATIONs.mp4`. Do not overwrite an existing file.
6. Produce exactly the requested duration at 1920x1080 and 60 fps, with `duration * 60` frames, H.264 High/yuv420p BT.709 video, fast start, and stereo 48 kHz AAC audio.
7. Check the finished file once with `ffprobe` and one full decode. Confirm duration, dimensions, frame rate, frame count, and audio/video streams, then report the output path and the clips used.
