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

#### About rsyslog.conf - remote syslog
       rsyslog.conf - rsyslogd(8) configuration file

       The rsyslog.conf file is the main configuration file for the
       rsyslogd(8) which logs system messages on *nix systems.  This
       file specifies rules for logging.  For special features see the
       rsyslogd(8) manpage. Rsyslog.conf is backward-compatible with
       sysklogd's syslog.conf file. So if you migrate from sysklogd you
       can rename it and it should work.

#### Commands to get the route info
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
