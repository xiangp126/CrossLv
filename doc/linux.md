### Linux Manipulation

#### How to execute sudo without password

refer to [Execute sudo without Password?](https://askubuntu.com/questions/147241/execute-sudo-without-password)

```bash
sudo vim /etc/sudoers

# add this line
$USER ALL=(ALL) NOPASSWD: ALL

:w !sudo tee %
```