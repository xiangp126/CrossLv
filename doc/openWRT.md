### OpenWRT
`WRT1200AC` and `WRT32X` from LINKSYS

#### Setup Time Machine Server using SMB directly

- [samba_configuration](https://openwrt.org/docs/guide-user/services/nas/samba_configuration)
- [**using-a-raspberry-pi-for-time-machine**](https://mudge.name/2019/11/12/using-a-raspberry-pi-for-time-machine/)
- [how-use-time-machine-backup-your-mac-windows-shared-folder](https://www.imore.com/how-use-time-machine-backup-your-mac-windows-shared-folder)
- [TroubleShooting](#troubleshooting)
    - [Cannot connect to TM disk on Home LAN](#errorcode65)

**! Importance !**
**Don't waster your time to modify `/etc/samba/smb.conf` or even `/var/etc/smb.conf`, both files will be overritten when restart smbd.**

you must modify `/etc/config/samba` to set your shared directory

Take a look at this file

```bash
config samba
        option workgroup 'WORKGROUP'
        option name 'OpenWrt'
        option description 'OpenWrt'
        option homes '0'

config sambashare
        option name 'misc'
        option users 'pi'
        option read_only 'no'
        option guest_ok 'no'
        option create_mask '755'
        option dir_mask '755'
        option path '/mnt/misc'

config sambashare
... ...

```

After modification, remember to restart `smbd`

#### Auto mount the partion | USB Storage

refer to [Automount the partition
](https://openwrt.org/docs/guide-user/storage/usb-drives)

```bash
# find the disk
opkg update && opkg install fdisk
fdisk -l

# install block
opkg update && opkg install block-mount
# block info

# manual mount the partion
mount /dev/sda1 /mnt/Dir

# should write mount info into fstab
cat /etc/config/fstab
block detect | uci import fstab

# re-check fstab
cat /etc/config/fstab
```

#### Setup Time Machine Server using AFP protocol
MacOS uses afp protocol other than samba, so implement afp on OpenWRT

- [netatalk_configuration](https://openwrt.org/docs/guide-user/services/nas/netatalk_configuration)
- [afp.conf](http://netatalk.sourceforge.net/3.0/htmldocs/afp.conf.5.html)

#### install netatalk
```bash
opkg update && opkg install avahi-utils netatalk
```

#### create new user

refer to [Create a non-privileged user in OpenWrt
](https://oldwiki.archive.openwrt.org/doc/howto/secure.access)

```bash
opkg update
opkg install shadow-useradd
useradd nicolaus

# However, you can't ssh to this user yet.
# To enable ssh access, you should make a password for that user
# create his home folder
# and most importantly indicate the shell of that user

passwd nicolaus
mkdir /home
mkdir /home/nicolaus
chown nicolaus /home/nicolaus

# add default shell '/bin/ash' for pi
vi /etc/passwd
   nicolaus:x:1000:1000:nicolaus:/home/nicolaus:/bin/ash
```

#### add user(pi) to an existing group(users)

```bash
usermod -a -G users pi

root@LEDE:~# grep users /etc/group
users:x:100:pi

root@LEDE:~# id pi
uid=1000(pi) gid=1000(pi) groups=1000(pi),100(users),1001(camera)
```

#### change the owner of a directory
```bash
# This method doesn't take into effect, the owner
# will be changed to root again.
root@OpenWrt:/mnt# chown pi DrDu_TM/
```

#### change the group owner of a directory
change the owner of `DrDu_TM/` from `root` to `users`

```bash
root@LEDE:/mnt# chgrp users DrDu_TM/

ls -alF
drwxrwxr-x    2 root     users         4096 Sep 14 14:37 DrDu_TM/
```

### share my `/etc/afp.conf`

```bash
;
; Netatalk 3.x configuration file
;

[Global]
; Global server settings
log file = /var/log/afpd.log
afp interfaces = br-lan

[DrDu_TM]
path = /mnt/DrDu_TM
time machine = yes
vol size limit = 0
valid users = pi @users
```

Note: using `WRT1200` the time it takes with first backup >= 12 hours, it is very slow! The Throttle maybe CPU.

#### Speed Up Time machines First back up
[speed-up-time-machine-backups-by-10x](https://blog.shawjj.com/speed-up-time-machine-backups-by-10x-f6274330dc6f)

- Speed up Time Machine Backups
- close all apps BEST OPTION

Then

- clear cache (but not required)
- go to Terminal

```bash
#$ sysctl debug.lowpri_throttle_enabled
#debug.lowpri_throttle_enabled: 1
sudo sysctl debug.lowpri_throttle_enabled=0
```

- While backing up - DO NOT use the computer
- After finished go back in Terminal enter

```bash
sudo sysctl debug.lowpri_throttle_enabled=1
```

- Which resets the best normal performance to the computer

<a id=troubleshooting></a>
### TroubleShooting

<a id=errorcode65></a>

- TimeMachine cannot connect to shared TM disk on home LAN with `OSStatus error 65`

refer to the last comment of this page posted by Andre77Mi
<https://discussions.apple.com/thread/7687265>

Then, after looking into thousand forums, I eventually found a solution that worked for me (thanks to user "niemepet" on Buffalo official forum).

**The point seems to use the AFP protocol instead of SMB**.

I re-wrote it to make it more "understandable" even for less advanced users:

You have to open Finder, then press Command-k to open the box which is used to connect to a server. Then, type afp://NAS address/TimeMachine, where "NAS address" is the NAS IP address (or name) and "TimeMachine" is your backup folder on the NAS. After that, just enter your login details.
