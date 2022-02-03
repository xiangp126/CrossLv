## MAC

### Disable SIP Mode
System Integrity Protection

```
sudo reboot
```
Press `Win + R` until Apple Logo appears<br>
At the top menu, launch Terminal

```bash
csrutil status
csrutil disable
# csrutil enable
```

### Create Encrypt Folder - dmg
Open `Disk Utility`

File - New from Directory

### hotkey with Dock
 key | Description
:---: | :---:
**Ctrl + Command + Q** | Lock screen
**command＋option＋D** | hide or reveal *`Dock`*

### Install Java8
```bash
brew update
brew cask install caskroom/versions/java8
```

### Upgrade OS to Catalina
Goto: [Macos Catalina Patcher](http://dosdude1.com/catalina/) and download the latest version.

Note: The upgrade step **will not** delete your existing files.

### [How to cool Macbook Pro](https://www.zhihu.com/question/19837256)

独显是mac的发热大户，即使是在低速运行下，都有15w的功耗。所以在不需要使用独显的时候手动禁用掉，可以降低mac的功耗，发热会得到明显改善，而且可以提高电池的续航！

- 在强制核显时，某些专业软件如PS仍然会使用独显
- 由于外接显示器需要独显，所以在强制核显时无法外接显示器，切记！！

```bash
# 在终端中输入,强制使用核显

sudo pmset -a GPUSwitch 0

# 如果想切换回来，则根据自己需要选择输入下面的代码
# 强制使用独显
sudo pmset -a GPUSwitch 1

# 自动切换显卡
sudo pmset -a GPUSwitch 2
```