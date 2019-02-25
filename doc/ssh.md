## ssh
### keylogin
```bash
cd ~
ssh-keygen -t rsa

cd .ssh
touch authorized_keys
chmod 600 authorized_keys
```
> Allow only key login and Deny root login | CentOS

```bash
sudo vim /etc/ssh/sshd_config
# search 'Password' and comment that line

# DEMON BEGIN
...
# change to any 'port' you like
Port 22
...
PermitRootLogin no
...
Password Authentiaction no
# DEMON END

sudo /etc/init.d/sshd restart
# or
sudo systemctl restart sshd.service
# and wait ...
```

### keepalive
> SSH Keep Alive from server side

```bash
sudo vim /etc/ssh/sshd_config

ClientAliveInterval 60
ClientAliveCountMax 5
```

### TroubleShoot
#### issue 1
```
Job for sshd.service failed because the control process exited with error code.
```

modify `/etc/selinux/config` and set **SELINUX=disabled**

```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#       targeted - Targeted processes are protected,
#       mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
