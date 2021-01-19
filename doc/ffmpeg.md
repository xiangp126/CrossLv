## ffmpeg
<https://www.ffmpeg.org/about.html>

### Install - for Mac
```bash
brew install ffmpeg
```

### Usage Content List
- [print the whole help page](#help)
- [look info](#info)
- [video format converter](#videoformatconverter)
- [compress video](#compress)
- [extract whole video](#extractvideo)
- [extract whole audio](#extractaudio)
- [blade duration of video](#bladeduration)
- [compress with subtitle](#subtitle)
- [extract subtitle from video](#extractsub)
- [Download M3U8 and Combine](#downloadm3u8)

<a id=help></a>
#### Print The Whole Help Page
```bash
Hyper fast Audio and Video encoder
usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...

Getting help:
    -h      -- print basic options
    -h long -- print more options
    -h full -- print all options (including all format and codec specific options, very long)
    -h type=name -- print all options for the named decoder/encoder/demuxer/muxer/filter/bsf/protocol
    See man ffmpeg for detailed description of the options.

Print help / information / capabilities:
-L                  show license
-h topic            show help
-? topic            show help
-help topic         show help
--help topic        show help
-version            show version
-buildconf          show build configuration
-formats            show available formats
-muxers             show available muxers
-demuxers           show available demuxers
-devices            show available devices
-codecs             show available codecs
-decoders           show available decoders
-encoders           show available encoders
-bsfs               show available bit stream filters
-protocols          show available protocols
-filters            show available filters
-pix_fmts           show available pixel formats
-layouts            show standard channel layouts
-sample_fmts        show available audio sample formats
-colors             show available color names
-sources device     list sources of the input device
-sinks device       list sinks of the output device
-hwaccels           show available HW acceleration methods

Global options (affect whole program instead of just one file):
-loglevel loglevel  set logging level
-v loglevel         set logging level
-report             generate a report
-max_alloc bytes    set maximum size of a single allocated block
-y                  overwrite output files
-n                  never overwrite output files
-ignore_unknown     Ignore unknown stream types
-filter_threads     number of non-complex filter threads
-filter_complex_threads  number of threads for -filter_complex
-stats              print progress report during encoding
-max_error_rate maximum error rate  ratio of errors (0.0: no errors, 1.0: 100% errors) above which ffmpeg returns an error instead of success.
-bits_per_raw_sample number  set the number of bits per raw sample
-vol volume         change audio volume (256=normal)

Per-file main options:
-f fmt              force format
-c codec            codec name
-codec codec        codec name
-pre preset         preset name
-map_metadata outfile[,metadata]:infile[,metadata]  set metadata information of outfile from infile
-t duration         record or transcode "duration" seconds of audio/video
-to time_stop       record or transcode stop time
-fs limit_size      set the limit file size in bytes
-ss time_off        set the start time offset
-sseof time_off     set the start time offset relative to EOF
-seek_timestamp     enable/disable seeking by timestamp with -ss
-timestamp time     set the recording timestamp ('now' to set the current time)
-metadata string=string  add metadata
-program title=string:st=number...  add program with specified streams
-target type        specify target file type ("vcd", "svcd", "dvd", "dv" or "dv50" with optional prefixes "pal-", "ntsc-" or "film-")
-apad               audio pad
-frames number      set the number of frames to output
-filter filter_graph  set stream filtergraph
-filter_script filename  read stream filtergraph description from a file
-reinit_filter      reinit filtergraph on input parameter changes
-discard            discard
-disposition        disposition

Video options:
-vframes number     set the number of video frames to output
-r rate             set frame rate (Hz value, fraction or abbreviation)
-s size             set frame size (WxH or abbreviation)
-aspect aspect      set aspect ratio (4:3, 16:9 or 1.3333, 1.7777)
-bits_per_raw_sample number  set the number of bits per raw sample
-vn                 disable video
-vcodec codec       force video codec ('copy' to copy stream)
-timecode hh:mm:ss[:;.]ff  set initial TimeCode value.
-pass n             select the pass number (1 to 3)
-vf filter_graph    set video filters
-ab bitrate         audio bitrate (please use -b:a)
-b bitrate          video bitrate (please use -b:v)
-dn                 disable data

Audio options:
-aframes number     set the number of audio frames to output
-aq quality         set audio quality (codec-specific)
-ar rate            set audio sampling rate (in Hz)
-ac channels        set number of audio channels
-an                 disable audio
-acodec codec       force audio codec ('copy' to copy stream)
-vol volume         change audio volume (256=normal)
-af filter_graph    set audio filters

Subtitle options:
-s size             set frame size (WxH or abbreviation)
-sn                 disable subtitle
-scodec codec       force subtitle codec ('copy' to copy stream)
-stag fourcc/tag    force subtitle tag/fourcc
-fix_sub_duration   fix subtitles duration
-canvas_size size   set canvas size (WxH or abbreviation)
-spre preset        set the subtitle options to the indicated preset
```

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
Note

- -`vn`                 disable video
- -`an`                 disable audio
- -`sn`                 disable subtitle

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

<a id=subtitle></a>
#### compress with subtitle

**!! Change File Encoding of SRT to UTF-8 First, or FFMPEG WILL ERR !!**

```bash
#ffmpeg -i subtitle.srt subtitle.ass
ffmpeg -i Inside.Man.2006.mp4 -vf subtitles=Inside.Man.2006.bd.chs.srt out.mp4

#ffmpeg -i Lantern.mp4 -vcodec libx264 -preset fast -crf 20 -vf "ass=Lantern.ass" out.mp4
```

<a id=extractsub></a>
#### extract subtitle from video
This would download the first subtitle track. If there are several, use 0:s:1 to download the second one, 0:s:2 to download the third one, and so on.

```
ffmpeg -i Movie.mkv -map 0:s:0 subs.srt
```

- -i: Input file URL/path.
- -map: Designate one or more input streams as a source for the output file.
- s:0: Select the subtitle stream.

<a id=downloadm3u8></a>
#### download M3U8 and combine all slices to whole video
for more detailed info, please refer [Teach You to Find M3U8 Manually
](https://github.com/xiangp126/XGot/blob/master/Teach%20You%20to%20Find%20M3U8%20Manually.md)

```bash
ffmpeg -i https://vip.okokbo.com/20180219/YLHVBngO/index.m3u8 -c copy -bsf:a aac_adtstoasc output.mp4
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
