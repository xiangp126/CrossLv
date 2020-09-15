### OpenWRT
~~My Router is `WRT1200AC`~~

#### Setup Time Machine Server using SMB directly

- [samba_configuration](https://openwrt.org/docs/guide-user/services/nas/samba_configuration)
- [**using-a-raspberry-pi-for-time-machine**](https://mudge.name/2019/11/12/using-a-raspberry-pi-for-time-machine/)
- [how-use-time-machine-backup-your-mac-windows-shared-folder](https://www.imore.com/how-use-time-machine-backup-your-mac-windows-shared-folder)

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

After modification, remember to restart smbd

#### Setup Time Machine Server using AFP protocol
MacOS uses afp protocol other than samba, so implement afp on OpenWRT

- [netatalk_configuration](https://openwrt.org/docs/guide-user/services/nas/netatalk_configuration)
- [afp.conf](http://netatalk.sourceforge.net/3.0/htmldocs/afp.conf.5.html)

#### install netatalk
```bash
opkg update && opkg install avahi-utils netatalk
```

#### add user(pi) to an existing group(users)

```bash
usermod -a -G users pi

root@LEDE:~# grep users /etc/group
users:x:100:pi

root@LEDE:~# id pi
uid=1000(pi) gid=1000(pi) groups=1000(pi),100(users),1001(camera)
```

#### change the group owner of a directory
change the owner of `DrDu_TM/` and `Savy_TM/` from `root` to `users`

```bash
root@LEDE:/mnt# chgrp users DrDu_TM/ Savy_TM/

ls -alF
drwxrwxr-x    2 root     users         4096 Sep 14 14:37 DrDu_TM/
drwxrwxr-x    2 root     users          160 Sep 13 23:52 Savy_TM/
```

### share my `afp.conf`

```bash
;
; Netatalk 3.x configuration file
;

[Global]
; Global server settings
log file = /var/log/afpd.log
afp interfaces = br-lan

[XX_TM]
path = /mnt/XX_TM
time machine = yes
vol size limit = 0
valid users = pi @users
```

Note: using wrt1200 the time it takes with first backup >= 12 hours, it is very slow! The Throttle maybe CPU.