
## Manual Install Chrome | Ubuntu
### Add Key:
```bash
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
```

### Set Repository:
```bash
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
```

### Install Package:
```bash
sudo apt-get update
sudo apt-get install google-chrome-stable
```

### chrome plugins
- stylish
	- Global dark style - changes everything to DARK
	- Midnight Surfing - Global Dark Style
- uBlock Origin