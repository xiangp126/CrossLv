## Linux Manipulation

### Configuration
--
#### Configure static IP address
```bash
auto eth0
iface eth0 inet static
address 192.168.1.36/24
gateway 192.168.1.1
```

#### nslookup
```bash
nslookup google.com
# specify dns server
nslookup google.com 8.8.8.8
```

### Configure DNS server manually
**IMPORTANT NOTE**: Dont separate DNS adresses with commas, write **nameserver** before each adress, like here

```bash
> sudo vim /etc/resolv.conf/

nameserver 8.8.8.8
nameserver 8.8.4.4
```

#### How to execute sudo without password

refer to [Execute sudo without Password?](https://askubuntu.com/questions/147241/execute-sudo-without-password)

```bash
sudo vim /etc/sudoers

# add this line
$USER ALL=(ALL) NOPASSWD: ALL

:w !sudo tee %
```

or add current user to group `sudo` (just take for example)

check `/etc/sudoers` for the exactly group name that have free sudo privilege on your system.

<div align=left><img src="../res/group_sudo.png" width=50%></div>

```bash
usermod –aG sudo UserName
```

### Tricks
--
#### How does `:w !sudo tee %` work

- https://unix.stackexchange.com/questions/301256/how-does-w-sudo-tee-work
- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work

```bash
# Already opened and edited a file
# To save your work

:w !sudo tee %
```

#### about rsyslog.conf - remote syslog
       rsyslog.conf - rsyslogd(8) configuration file

       The rsyslog.conf file is the main configuration file for the
       rsyslogd(8) which logs system messages on *nix systems.  This
       file specifies rules for logging.  For special features see the
       rsyslogd(8) manpage. Rsyslog.conf is backward-compatible with
       sysklogd's syslog.conf file. So if you migrate from sysklogd you
       can rename it and it should work.

#### Get route info
- netstat

```bash
netstat -rn
```

- ip command

```bash
ip route
```

- route command

```bash
route -n
```