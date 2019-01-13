## ffmpeg
### install
- for mac

```bash
brew install ffmpeg
```

### codecs
```bash
# ffmpeg -codecs

h264 for H.264
hevc for H.265
```

### vide format converter
```bash
ffmpeg -i who.flv -vcodec h264 who.mp4
```

### compress video
only compress video, not influence audio

```bash
# vcodec is an alias of codec:v, namely c:v
# acodec => codec:a => c:a
ffmpeg -i input.mp4 -c:v libx264 -preset veryslow -crf 20 -c:a copy output.mp4
```


### parameters explain
- -vcodec codec

> force video codec ('copy' to copy stream)