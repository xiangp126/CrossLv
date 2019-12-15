## mac

### Disable SIP Mode
System Integrity Protection

```
sudo reboot
```
> Press `Win + R` until Apple Logo appears<br>
At the top menu, launch Terminal

```
csrutil status
csrutil disable
# csrutil enable
```

### Create Encrypt Folder - dmg

Open `Disk Utility`

File - New from Directory

### hotkey with Dock

 key | Explain
:---: | :---:
**Ctrl + Command + Q** | Lock screen
**command＋option＋D** | hide or reveal *`Dock`*


### Install Java8
```bash
brew update
brew cask install caskroom/versions/java8
```