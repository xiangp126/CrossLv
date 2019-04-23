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
# Subtitles
sub-auto=fuzzy
sub-text-font-size=48
sub-codepage=utf8:gb18030
window-scale=0.5
```

#### input.conf
```bash
RIGHT seek 1
LEFT seek 1
UP add volume 5
DOWN add volume -5
```

### play video
```bash
mpv [url]
```

### ShortCut Key
#### 播放控制
操作|反向操作|行为
:---:|:---:|:---:
p	|Space	|暂停、继续播放
/	|*|减少/增加音量
9	|0|	减少/增加音量（数字键盘区的9、0不可用）
m	 |	|静音
←	|→|	快退/快进5秒
↑	|↓|	快进/快退1分钟
<	|>|	上一个/下一个（播放列表中）
Enter	|| 	下一个（播放列表中）
l(小写L) ||设定/清除 A-B循环点
L	 	||循环播放
I (大写 i)	||显示当前文件名
s	||截屏，有字幕
S	||截屏，无字幕
o	||显示进度条与时间，2 秒后消失
q	 	||停止播放并退出
Q	 	||保存当前播放进度并退出，播放同样文件从上次保存进度继续播放

#### 字幕控制
操作|反向操作|行为
:---:|:---:|:---:
V	|| 	关闭/开启字幕
j	|J|	循环切换可用字幕轨
x	|z|	字幕延迟 +/- 0.1秒
r	|t|	上移/下移字幕位置

#### 视频控制
操作|MAC OS X|行为
:---:|:---:|:---:
_(下划线)	| |	循环切换可用视频轨
A	 	||循环切换视频画面比例
Alt+0	|Command+0 on OS X|	0.5倍源视频画面大小
Alt+1	|Command+1 on OS X|	1倍源视频画面大小
Alt+2	|Command+2 on OS X|	2倍源视频画面大小

#### 音频控制
操作|反向操作|行为
:---:|:---:|:---:
\#	 	||循环切换可用音频轨
Ctrl +	|Ctrl -|	音轨延迟+/- 0.1秒

#### 窗口控制
操作|行为
:---:|:---:
T	|窗口始终置顶
f	|进入/退出全屏
ESC	|退出全屏
Command+f OS X Only|切换全屏

#### 鼠标操作
操作|行为
---|---
鼠标左键双击	|进入/退出全屏
鼠标右键单击	|暂停/继续播放