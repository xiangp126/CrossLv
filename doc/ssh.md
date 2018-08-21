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