## VSCode

- [Plugins that I Recommend](#plugins)
    - [vim](#vim)
    - [Remote - SSH](#remotessh)
    - [GitLens - Git Supercharged](#gitlens)
- [Useful Config and Command Tips](#configs)
    - [Get paste board when connect to remote tmux](#pastefromtmux)
    - [Open file on a new tab](#openfileonnewtab)
    - [Go back to origilal location after F12](#goback)
    - [Go to desired files or lines](#goto)
    - [Search specific function in current file](#searchfunction)
    - [Search for text (can be a function name) in all files](#searchtext)
    - [Search specific commit through commit message using GitLens](#searchcommit)
    - [Python function cannot jump to its definition](#pythonjump)
- [Troubleshooting using VSCode](#troubleshooting)

<a id=plugins></a>
### Plugins that I Recommend

<a id=vim></a>
#### Vim
Vim emulation for VSCode

<a id=remotessh></a>
#### Remote - SSH

Open any folder on a remote machine using SSH and take advantage of the full features of VSCode. Featured as `sshfs` on Linux.

- Template for `SSH config`

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

Then you could

```bash
ssh remotedev
# it equals to
ssh -p 22 Annoymous@192.168.1.10 -i ~/.ssh/id_rsa_MyPrivate
```

<a id=gitlens></a>
#### GitLens - Git Supercharged
Highly recommended plugin

On Windows, use `Ctrl + Click` to _Show Commits_

---
<a id=configs></a>
### Useful Config and Command Tips

<a id=pastefromtmux></a>
#### Get paste board when connect to remote tmux

    on Windows, **Shift + "Mouse Choose"** can paste contents from tmux

<a id=openfileonnewtab></a>
#### Open file on a new tab

    File -> Preference -> Settings -> Workbench ->Editor Management ->Enable Preview

*uncheck `Enable Preview`, then a new opened file will appear in on a new tab*

<a id=goback></a>
#### Go back to origilal location after search function's definition (F12)
    Go -> Back
Shortcut Key: `Alt + LeftArrow`

<a id=goto></a>
#### Go to desired files or lines
- Go to desired files

`Ctrl + P` followed by desired file name.

- Go to desired lines

```bash
# Original the shortcut key is `Ctrl + G`
# due to conflict, change it to `Ctrl + '`
    File -> Preferences -> Keyboard Shortcuts
    Type "go to line" in the search bar
    and then edit the Keybinding column
```

<a id=searchfunction></a>
#### Search specific function in current file
    Ctr + P, followed by symbol @

Then Type your desired function name. For Example:

    Ctrl + P, then @write_data

<a id=searchtext></a>
#### Search for text (can be a function name) in all files in a directory | show in sidebar

You can do `Edit`->`Find in Files` (or `Ctrl+Shift+F` - default key binding, `Cmd+Shift+F` on MacOS) to search the Currently open Folder.

<a id=searchcommit></a>
#### Search specific commit through commit message using GitLens

`CMD + Shift + P` for Mac, `Ctrl + Shift + P` for Windows

<div align=left><img src="../res/GitLens commit message.png" width=95%></div>

then type `search commits` followed by Searching Commit Messages or Author Info

<div align=left><img src="../res/GitLens show commits.png" width=95%></div>

<a id=pythonjump></a>
#### Python function cannot jump to its definition
~~Install Pylance in vscode extension market~~

then change `python language server` in the settings from Default to Microsoft

<a id=troubleshooting></a>
### Troubleshooting using VSCode
- Bug Description

```bash
Missing or invalid credentials.
Error: connect ECONNREFUSED /var/folders/tx/53fffl0j51qb47mhnlf8zsdc0000gn/T/vscode-git-1d38026c7f.sock
at PipeConnectWrap.afterConnect [as oncomplete] net.js:1056:14) {
      errno: 'ECONNREFUSED',
                   code: 'ECONNREFUSED',
                     syscall: 'connect',
                       address: '/var/folders/tx/53fffl0j51qb47mhnlf8zsdc0000gn/T/vscode-git-1d38026c7f.sock'

}
Missing or invalid credentials.
Error: connect ECONNREFUSED /var/folders/tx/53fffl0j51qb47mhnlf8zsdc0000gn/T/vscode-git-1d38026c7f.sock
at PipeConnectWrap.afterConnect [as oncomplete] net.js:1056:14) {
      errno: 'ECONNREFUSED',
                   code: 'ECONNREFUSED',
                     syscall: 'connect',
                       address: '/var/folders/tx/53fffl0j51qb47mhnlf8zsdc0000gn/T/vscode-git-1d38026c7f.sock'

}
remote: No anonymous write access.
fatal: Authentication failed for 'https://github.com/username/repo.git/'
```

- Resolve Solution
Close current Terminal and create a new one in VsCode. If you also use Tmux in the terminal,
kill current tmux session and also create a new one.

The problem will be fixed. April 2, 2021