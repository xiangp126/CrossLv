## VS-Code

### Plugins Recommended
#### Remote - SSH

Open any folder on a remote machine using SSH and take advantage of VS Code's full feature set

**Greate: same as `sshfs` on Linux**

- Template for ssh config

```bash
# put these contents under ~/.ssh/config
# refer https://linuxize.com/post/using-the-ssh-config-file
Host remotedev
    HostName 192.168.1.10
    User Annonymous
    Port 22
    IdentityFile ~/.ssh/id_rsa_MyPrivate

Host tyrell
    HostName yrell.com.ca

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

Then

```bash
ssh remotedev
# equals
ssh -p 22 Annoymous@192.168.1.10 -i ~/.ssh/id_rsa_MyPrivate
```

#### Vim

Vim emulation for VS Code

### Useful Config and Command Tips

#### Get paste board when connect to remote `tmux`

    on Windows **Shift + "Mouse Choose"** can paste contents from tmux

#### Open file on new tab

    File -> Preference -> Settings -> Workbench ->Editor Management ->Enable Preview

*uncheck `Enable Preview`, then a new opened file will appear in on a new tab*

#### Go back to origilal location after search function's definition(F12)
    Go -> Back
Shortcut Key: Alt + LeftArrow

#### Go to desired files
    Ctrl + P
Then Type file name.

#### Search specific function
    Ctr + P, followed by symbol @

Then Type your desired function name. For Example:

    Ctrl + P, then @write_data
