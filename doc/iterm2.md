## iterm2
### Load iterm preference from template
    iterm2 -> preference -> general<br>
    check 'Load preferences from a custom folder ...'<br>
    and then **Browser** ~/Public/iterm2/com.googlecode.iterm2.plist

### Load myself color preset - darkcoding-iterm2
    iterm2 -> profiles -> colors -> Color Presets -> import
    choose ./iterm2/darkcoding-iterm2.itermcolors

### Terminal Color
    foreground #b2b2b2<br>
    background #000000

### iterm2 Font Install Them First
    font -> monaco 17pt<br>
    Non-ASCII font source code pro for powerline 14pt

### for _fzf_ use _Alt_ mapping
    Q: How do I make the option/alt key act like Meta or send escape codes?

    A: Go to Preferences->Profiles tab. Select your profile on the left,
and then open the Keyboard tab. At the bottom is a set of buttons
that lets you select the behavior of the Option key. For most users, Esc+ will be the best choice.

### How to Clear Terminal Messy Code
such As: `0;97;16M0;97;16m.`

```bash
reset
```