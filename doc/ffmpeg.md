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

### parameters explain
- -vcodec codec

       force video codec ('copy' to copy stream)