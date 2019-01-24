## ffmpeg
<https://www.ffmpeg.org/about.html>

### Install - for Mac
```bash
brew install ffmpeg
```

### Usage Content List
- [look info](#info)
- [video format converter](#videoformatconverter)
- [compress video](#compress)
- [extract whole video](#extractvideo)
- [extract whole audio](#extractaudio)
- [blade duration of video](#bladeduration)

<a id=info></a>
#### look info
**Video: h264** | **Audio: aac**

```bash
# ffmpeg -i who.mp4
ffmpeg version 4.1 Copyright (c) 2000-2018 the FFmpeg developers
  built with Apple LLVM version 10.0.0 (clang-1000.11.45.5)
  configuration: --prefix=/usr/local/Cellar/ffmpeg/4.1_1 --enable-shared --enable-pthreads --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-ffplay --enable-gpl --enable-libmp3lame --enable-libopus --enable-libsnappy --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid --enable-lzma --enable-opencl --enable-videotoolbox
  libavutil      56. 22.100 / 56. 22.100
  libavcodec     58. 35.100 / 58. 35.100
  libavformat    58. 20.100 / 58. 20.100
  libavdevice    58.  5.100 / 58.  5.100
  libavfilter     7. 40.101 /  7. 40.101
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  3.100 /  5.  3.100
  libswresample   3.  3.100 /  3.  3.100
  libpostproc    55.  3.100 / 55.  3.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'who.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf58.20.100
  Duration: 00:11:01.14, start: 0.000000, bitrate: 1490 kb/s
    Stream #0:0(und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, bt709), 1280x720, 1167 kb/s, 23.98 fps, 23.98 tbr, 16k tbn, 47.95 tbc (default)
    Metadata:
      handler_name    : VideoHandler
    Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 317 kb/s (default)
    Metadata:
      handler_name    : SoundHandler
At least one output file must be specified
```

<a id=videoformatconverter></a>
#### video format converter

convert from `flv` to `mp4`, notice suffix

```bash
ffmpeg -i who.flv -vcodec h264 who.mp4
```

<a id=compress></a>
#### compress video
only compress video, not influence audio

```bash
# vcodec is an alias of codec:v, namely c:v
# acodec => codec:a => c:a
ffmpeg -i input.mp4 -c:v libx264 -preset veryslow -crf 20 -c:a copy output.mp4
```

<a id=extractvideo></a>
#### extract whole video
```bash
ffmpeg -i who.mp4 -vcodec copy -an whoNoAudio.mp4
```

<a id=extractaudio></a>
#### extract whole audio
```bash
ffmpeg -i who.mp4 -acodec copy -vn whoAudio.aac
```

or

```
ffmpeg -i who.mp4 -acodec copy -vn whoAudio.m4a
```

<a id=bladeduration></a>
#### blade duration of video
start from #5 minutes, duration of 10 minutes

```bash
ffmpeg -ss 00:05:00 -t 00:10:00 -i input.mp4 -vcodec copy -acodec copy output.mp4
```

### Parameters Explain
- -vcodec codec

> force video codec (`copy` to copy stream)

- -acodec codec

> force audio codec (`copy` to copy stream)

- -vn

> disable video

- -an

> disable audio

- -ss time_off

> set the start time offset

- -t duration

> record or transcode "duration" seconds of audio/video

- -to time_stop

> record or transcode stop time

### Codecs
```bash
# ffmpeg -codecs
...

h264 for H.264
hevc for H.265
```