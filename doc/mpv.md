## mpv
<https://github.com/mpv-player/mpv>
### install
- Mac

```bash
brew cask install mpv
```

### config path
```bash
cd ~/.config/mpv
```

`mpv.conf` & `input.conf`

#### mpv.conf
```bash
window-scale=0.5
```

#### input.conf
```bash
RIGHT seek 5
LEFT seek -5
UP add volume 5
DOWN add volume -5
```

### play video
```bash
mpv [url]
```