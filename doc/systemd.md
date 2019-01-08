## [systemd](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

services that was supported has a configuration under **/usr/lib/systemd/system/**

has a soft link under **/etc/systemd/system/** for that boots with system up

when system boots up, it executes configurations under `/etc/systemd/system`

### for sshd
#### /usr/lib/systemd/system/sshd.service
```ruby
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

#### /etc/sysconfig/sshd
```bash
# Configuration file for the sshd service.

# The server keys are automatically generated if they are missing.
# To change the automatic creation uncomment and change the appropriate
# line. Accepted key types are: DSA RSA ECDSA ED25519.
# The default is "RSA ECDSA ED25519"

# AUTOCREATE_SERVER_KEYS=""
# AUTOCREATE_SERVER_KEYS="RSA ECDSA ED25519"

# Do not change this option unless you have hardware random
# generator and you REALLY know what you are doing

SSH_USE_STRONG_RNG=0
# SSH_USE_STRONG_RNG=1
```

#### boot with system up
```ruby
ll /usr/lib/systemd/system/sshd.service
-rw-r--r--. 1 root root 361 Nov 20  2015 /usr/lib/systemd/system/sshd.service
```

enable boot with system up

```
systemctl enable sshd.service

ll /etc/systemd/system/multi-user.target.wants/sshd.service
lrwxrwxrwx. 1 root root 36 Feb  6  2018 /etc/systemd/system/multi-user.target.wants/sshd.service -> /usr/lib/systemd/system/sshd.service
```

#### command
```ruby
systemctl start sshd
systemctl stop sshd
systemctl reload sshd
# start with system up
systemctl enable sshd
systemctl disable sshd
systemctl is-enabled sshd
```

#### systemctl status sshd
```bash
# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2018-11-15 11:48:25 CST; 1 months 23 days ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1446 (sshd)
   CGroup: /system.slice/sshd.service
           └─1446 /usr/sbin/sshd -D
...
```

### for keepalived
#### /usr/lib/systemd/system
```bash
cd /usr/lib/systemd/system
vim keepalived.service
```

#### /usr/lib/systemd/system/keepalived.service
```ruby
Description=DPVS and VRRP High Availability Monitor
After=network.target
ConditionPathExists=/etc/keepalived/keepalived.conf

[Service]
Type=forking
#PIDFile=/var/run/keepalived.pid
EnvironmentFile=-/etc/sysconfig/keepalived
ExecStartPre=/usr/bin/rm -f /var/run/keepalived.pid
ExecStart=/usr/bin/keepalived $KEEPALIVED_OPTIONS
ExecStop=/bin/killall keepalived
ExecReload=/bin/kill -s HUP $MAINPID
ExecStopPost=/usr/bin/sleep 1
KillMode=process
#LimitCore=infinity

[Install]
WantedBy=multi-user.target
```

#### /etc/sysconfig/keepalived
```
# Options for keepalived. See `keepalived --help' output and keepalived(8) and
# keepalived.conf(5) man pages for a list of all options. Here are the most
# common ones :
#
# --vrrp               -P    Only run with VRRP subsystem.
# --check              -C    Only run with Health-checker subsystem.
# --dont-release-vrrp  -V    Dont remove VRRP VIPs & VROUTEs on daemon stop.
# --dont-release-ipvs  -I    Dont remove IPVS topology on daemon stop.
# --dump-conf          -d    Dump the configuration data.
# --log-detail         -D    Detailed log messages.
# --log-facility       -S    0-7 Set local syslog facility (default=LOG_DAEMON)
#

KEEPALIVED_OPTIONS="-D"
```

#### command
```ruby
systemctl start keepalived
systemctl stop keepalived
systemctl reload keepalived
# start with system up
systemctl enable keepalived
systemctl disable keepalived
systemctl is-enabled keepalived
```

#### systemctl status keepalived.service
```bash
# systemctl status keepalived.service
● keepalived.service
   Loaded: loaded (/usr/lib/systemd/system/keepalived.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2019-01-07 20:30:00 CST; 14h ago
  Process: 10081 ExecReload=/bin/kill -s HUP $MAINPID (code=exited, status=0/SUCCESS)
  Process: 25101 ExecStart=/usr/bin/keepalived $KEEPALIVED_OPTIONS (code=exited, status=0/SUCCESS)
  Process: 25098 ExecStartPre=/usr/bin/rm -f /var/run/keepalived.pid (code=exited, status=0/SUCCESS)
 Main PID: 25102 (keepalived)
   CGroup: /system.slice/keepalived.service
           ├─10083 /usr/bin/keepalived -D
           ├─25102 /usr/bin/keepalived -D
           └─25104 /usr/bin/keepalived -D

Jan 08 10:17:10 816375385 Keepalived_healthcheckers[10083]: IPVS: Resource temporarily unavailable
Jan 08 10:17:10 816375385 Keepalived_healthcheckers[10083]: Using LinkWatch kernel netlink reflector...
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Netlink reflector reports IP 10.2.10.175 added
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Netlink reflector reports IP fe80::a236:9fff:fe74:e840 added
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Registering Kernel netlink reflector
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Registering Kernel netlink command channel
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Registering DPVS gratuitous ARP.
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Opening file '/etc/keepalived/keepalived.conf'.
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Configuration is using : 58484 Bytes
Jan 08 10:17:10 816375385 Keepalived_vrrp[25104]: Using LinkWatch kernel netlink reflector...

```