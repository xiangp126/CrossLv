## VS-Code

### Plugin
- Remote - SSH

Essential. same as sshfs on Linux

Template for ssh config

```bash
# put these contents under ~/.ssh/config
# refer https://linuxize.com/post/using-the-ssh-config-file
Host remotedev
    HostName 192.168.1.10
    User daenerys
    Port 7654
    IdentityFile ~/.ssh/myprivate.key

Host tyrell
    HostName 192.168.10.20

Host martell
    HostName 192.168.10.50

Host *ell
    user oberyn

Host * !martell
    LogLevel INFO

Host *
    User root
    Compression yes

```

then ssh `remotedev `

- Vim

### Useful Config

- get paste board when connect to remote `tmux`

on Windows **Shift + "Mouse Choose"** can paste contents from tmux

- open file on new tab

_File -> Preference -> Workbench ->Editor Management ->Enable Preview_

unchech Preview, then can open file on a new tab