### Linux Manipulation

#### How to execute sudo without password

refer to [Execute sudo without Password?](https://askubuntu.com/questions/147241/execute-sudo-without-password)

```bash
sudo vim /etc/sudoers

# add this line
$USER ALL=(ALL) NOPASSWD:ALL

:w !sudo tee %
```

#### How does `:w !sudo tee %` work

- https://unix.stackexchange.com/questions/301256/how-does-w-sudo-tee-work
- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work

```bash
# Already opened and edited a file
# To save your work

:w !sudo tee %
```