## aircrack-ng
Use `aircrack-ng` utility to crack WIFI password

### Crack WIFI | WPA
```bash
# check your wireless card symbol
ifconfig
iwconfig

# assume your wireless card that was used for attacking is wlan0
airodump-ng wlan0

# assume the WIFI signal you want to crack
# name: HackMePlease, channel: 6
# change the mode of wireless card from managed to monitor
ifconfig wlan0 down
# and set the channel the same as the WIFI signal you want to crack
iwconfig wlan0 mode monitor channel 6
ifconfig wlan0 up

# xx
airodump-ng wlan0

# xx
aireplay-ng
```

