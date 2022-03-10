### Linux Manipulation

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

<div align=left><img src="../res/group_sudo.png" width=90%></div>

```bash
usermod –aG sudo UserName
```

#### How does `:w !sudo tee %` work

- https://unix.stackexchange.com/questions/301256/how-does-w-sudo-tee-work
- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work

```bash
# Already opened and edited a file
# To save your work

:w !sudo tee %
```

#### Get route info
```bash
netstat -rn
```

or

```bash
ip route
```

or

```bash
route -n
```