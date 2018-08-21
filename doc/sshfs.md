## sshfs
ssh file system | virtual technology

```
https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
https://lutao.me/ssh/sshfs/fuse/2017/04/19/sshfs.html
```

## Caution
cd out of your **mount point** before 'sshfs action'

## MAC
```
brew cask install osxfuse
brew install sshfs

cd
mkdir rdisk
sshfs root@10.123.16.46: rdisk/

df -h
root@10.123.16.46:       1.1T  264G  849G  24% /root/rdisk

- unmount | umount
diskutil unmount ~/rdisk
umount ~/rdisk
```
## Ubuntu | CentOS
```
yum install sshfs
apt-get install sshfs
```

## Permanently Mounting
```
sudo vim /etc/fstab

...
/dev/vdb /data          ext4    defaults  1      2
sshfs#root@xxx.xxx.xxx.xxx:~ /mnt/droplet
```