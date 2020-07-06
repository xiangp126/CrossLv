## sshfs
_ssh file system_

<https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh>

<https://lutao.me/ssh/sshfs/fuse/2017/04/19/sshfs.html>

**Caution**: `cd` out of your **mount point** before sshfs **mount** operation

### Install `sshfs`
#### for `Mac`
```bash
brew cask install osxfuse
brew install sshfs
```

or manually install **both** `osxfuse.dmg` and `sshfs.dmg` from <https://github.com/osxfuse>

#### for `Linux`
```bash
yum install sshfs
apt-get install sshfs
```

### Usage Illustrate
#### mount
```bash
sshfs user@x.x.x.x:/remote/path /local/path/
```

#### check
```bash
df -h
user@x.x.x.x:       1.1T  264G  849G  24% /local/path
```

#### umount
```bash
umount /local/path
```

for `mac` may need

```bash
diskutil umount /local/path
# Resource busy -- try 'diskutil unmount'
diskutil umount force /local/path
```

#### specify `IdentityFile`
- -o SSHOPT=VAL ssh options (see man ssh_config)
- -o `IdentityFile`=`/path/to/key`

```bash
sshfs user@x.x.x.x:/remote/path /local/path/ -o IdentityFile=/path/to/key
```

compare with `ssh`, Notice: **key was private key**

```bash
ssh -i /path/to/key user@x.x.x.x
```

#### permanent mounting
```bash
sudo vim /etc/fstab

...
/dev/vdb /data          ext4    defaults  1      2
sshfs#root@xxx.xxx.xxx.xxx:~ /mnt/droplet
```