### /etc/sudoers

### How to execute sudo without password

[Execute sudo without Password?](https://askubuntu.com/questions/147241/execute-sudo-without-password)

**Assume `Jack` is the target user.**

#### Part: Pre-Action
```bash
# Highly suggest switching to root before any actions to /etc/sudoers.
sudo -i
```

#### Part: Solution 1

```bash
sudo vim /etc/sudoers

# add this line
Jack ALL=(ALL) NOPASSWD: ALL
```

and then forcely write the file

```bash
:w !sudo tee %
```

#### Part: Solution 2 - add current user to `sudo` group

Just take for example. Please check `/etc/sudoers` for the exactly group name that have free sudo privilege on your system.

Change

```bash
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
```

=>

```bash
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
```

and then add `Jack` to `sudo` group

```
usermod –aG sudo Jack
```

#### [Rescue an invalid /etc/sudoers](https://askubuntu.com/questions/73864/how-to-modify-an-invalid-etc-sudoers-file) - Verified !!

How do I edit an invalid sudoers file? It throws the below error and it's not allowing me to edit again to fix it.

Here is what happens:

```bash
$ sudo visudo
>>> /etc/sudoers: syntax error near line 28 <<<
sudo: parse error in /etc/sudoers near line 28
sudo: no valid sudoers sources found, quitting
```

First, you try `pkexec` but it doesn't help

```bash
pkexec visudo
```

When this happens to a non-GUI system (your production server, maybe) the `pkexec` fails with this error message:

```bash
polkit-agent-helper-1: error response to PolicyKit daemon: GDBus.Error:org.freedesktop.PolicyKit1.Error.Failed: No session for cookie
==== AUTHENTICATION FAILED ===
Error executing command as another user: Not authorized
```

In this situation, using `pkttyagent` can be helpful. If you want to remove a corrupted file in `sudoers.d` directory, use this:

```bash
pkttyagent -p $(echo $$) | pkexec rm /etc/sudoers.d/FILENAME
```

If you want to recover the default `/etc/sudoers`, you can use this [gist](https://gist.github.com/alitoufighi/679304d9585304075ba1ad93f80cce0e) to copy the default configurations, putting it in a non-root accessed place (e.g. your $HOME). Then, you can overwrite your sudoers file:

```bash
pkttyagent -p $(echo $$) | pkexec cp ~/sudoers /etc/sudoers
```

**NOTE**: Using this approach, after running your command, **probably your access to the shell will be gone**. But I'm sure losing one shell session is much better than losing your server! (According to the manpage, this is the normal behavior: When its services are no longer needed, the process can be killed.)


---

#### The principle of how this trick `:w !sudo tee %` works

- https://unix.stackexchange.com/questions/301256/how-does-w-sudo-tee-work
- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work

```bash
:w !sudo tee %
```

The structure `:w !cmd` means "write the current buffer piped through command".

So you can do, for example `:w !cat` and it will pipe the buffer through cat.

Now `%` is the FILENAME associated with the buffer.

So `:w !sudo tee %` will pipe the contents of the buffer through sudo tee FILENAME.

This effectively writes the contents of the buffer out to the file.
