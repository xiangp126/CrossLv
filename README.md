### Illustrate
- This project aims to provide and persist **Cosy Programming Environment** on Linux and Mac
- Release more time on coding itself rather than installing tools time and time again boringly
- Done everything even from fresh OS installation all in one-key
- Different mode satisfies different needs

<table width=100%>
    <tr align=center>
        <th colspan=2> Mode </th>
        <th>Need Root Privilege</th>
        <th> Package Location</th>
        <th>Used For</th>
    </tr>
    <tr>
        <td colspan=2 align=center>Home Mode</td>
        <td align=center>&Chi;</td>
        <td align=center><b>$HOME/.usr</b></td>
        <td align=center>Public Machine</td>
    </tr>
    <tr>
        <td rowspan=2>Root Mode</td>
        <td>Default</td>
        <td align=center>&radic;</td>
        <td rowspan=2 align=center><b>/usr/local</b></td>
        <td align=center>Private Machine</td>
    </tr>
        <tr>
        <td>Simple</td>
        <td align=center>&radic;</td>
        <td>Temporary Used Machine</td>
    </tr>
    <tr>
        <td colspan=2 align=center>Mixed Mode</td>
        <td align=center>&radic;</td>
        <td align=center><b>$HOME/.usr</td>
        <td align=center>Private Machine</td>
    </tr>
</table>

- Demo for the `recursive` procedure
![](./res/persistlv.gif)

> It's great if this project may help you though it aimed to my personal use at the beginning<br>
> Latest released version: v4.0

### Prerequisite
> You should have full Internet access. if not, refer [squid.md](./doc/squid.md) or [ssh-proxy.md](./doc/ssh-proxy.md) to establish connection<br>
> On Ubuntu, /bin/sh was linked to /bin/dash by default, correct it to /bin/bash

```bash
sudo ln -sf /bin/bash /bin/sh
ls -l /bin/sh
lrwxrwxrwx 1 root root 9 Mar 29 17:04 /bin/sh -> /bin/bash*
```

### Lazy Deploy
#### clone repo
```git
git clone https://github.com/xiangp126/Giggle crosslv
```

#### help message
```bash
sh oneKey.sh
```

```
[NAME]
    oneKey.sh -- setup my working environment with just single command

[SYNOPSIS]
    sh oneKey.sh < home | root | mixed > [simple | full]
    sh oneKey.sh [summary | help]

[EXAMPLE]
    sh oneKey.sh
    sh oneKey.sh home
    sh oneKey.sh root
    sh oneKey.sh summary
    sh oneKey.sh root simple

[DESCRIPTION]
    help -- print the help messages
    home -- install packages into $HOME/.usr/
    root -- install packages into /usr/local/
    mixed - install packages into $HOME.usr/ but with sudo privilege
    simple  -- simple install level, only key vim/tmux plugins
    summary -- show installation summary

[TROUBLESHOOTING]
    if 'sh $execName' can not be excuted, ensure /bin/sh linked to /bin/bash
    ln -s /bin/bash /bin/sh
                     _     _   _
 _ __   ___ _ __ ___(_)___| |_| |_   __
| '_ \ / _ \ '__/ __| / __| __| \ \ / /
| |_) |  __/ |  \__ \ \__ \ |_| |\ V /
| .__/ \___|_|  |___/_|___/\__|_| \_/
|_|
```

#### install routine
deploy using `root` mode

```bash
sh oneKey.sh root
```

or using `home` mode

```bash
sh oneKey.sh home
```

### Tips of Key Script
> autoHandle.sh and makeLink.sh was automatically called by oneKey.sh, but their function can be used outside this project, so separate them alone.

#### autoHandle.sh
> comment on/off one of them to add/remove from tracking

```bash
trackFiles=(
    ".vimrc"
    ".tmux.conf"
    ".gitconfig"
    ".gitignore"
    ".bashrc"
    ".ycm_extra_conf.py"
)
```

```bash
sh autoHandle.sh

[NAME]
    $execName -- auto backup/restore key files of current linux env.

[SYNOPSIS]
    sh $execName [restore | backup | track | auto | regret | clean]

[EXAMPLE]
    sh $execName backup
    sh $execName track
    sh $execName restore
    sh $execName auto

[TROUBLESHOOTING]
    if 'sh $execName' can not be excuted, ensure /bin/sh linked to /bin/bash
    ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup tracked files under environment to ${backupDir}/
    track   -> deploy tracked files from 'backup-ed' to ${trackDir}/
    restore -> restore tracked files to environment from ${trackDir}/
    regret  -> regret previous 'restore' action as medicine
    auto    -> run 'backup' & 'track' as pack
    clean   -> clean ${backupDir}.*/, but reserve main backup dir
```

#### makeLink.sh
> generate soft link for [tools](./tools) into PATH

```bash
sh makeLink.sh

[NAME]
    makeLink.sh -- make link from ~/myGit/crosslv/tools/
                             to   ~/.usr/bin/
[USAGE]
    sh makeLink.sh [install | uninstall | help]

[EXAMPLE]
    sh makeLink.sh
    sh makeLink.sh install

[TROUBLESHOOTING]
    ~/.usr/bin/ should be placed in PATH
                 _          _ _       _
 _ __ ___   __ _| | _____  | (_)_ __ | | __
| '_ ` _ \ / _` | |/ / _ \ | | | '_ \| |/ /
| | | | | | (_| |   <  __/ | | | | | |   <
|_| |_| |_|\__,_|_|\_\___| |_|_|_| |_|_|\_\

```
```bash
sh makeLink.sh install
```

### Other Goodies
- [Latch](https://github.com/xiangp126/latch) - one-click lazy of OpenGrok
- [Let-Tmux](https://github.com/xiangp126/let-tmux) - lazy deploy of tmux and enjoy it
- [Let-Git](https://github.com/xiangp126/let-git) - update to latest stable version of Git
- [Let-Unlatch](https://github.com/xiangp126/let-unlatch) - lazy deploy that 'you knows' on VPS

### License
The [MIT](./LICENSE.txt) License (MIT)