## Crosslv
- Goal to deploy working/programming environment by 'oneKey' stroke
- Save time and enjoy more with help of wonderful tools and plugins
- Two modes deploy selection
    - home | root
    - without root privilege, normally install packages into $HOME/.usr
    - with root privilege, normally install packages into /usr/local
- Crossing Linux platforms, verified on
    - Ubuntu | CentOS | MacOS
    - On Ubuntu and MacOS whole installation takes little time
    - On CentOS expecially 6 may compile GCC supporting C++11 first, taking disk space 5G+
- A glimpse of the screenshots
![](https://github.com/xiangp126/crosslv/blob/master/screenshots/ycm.png)
![](https://github.com/xiangp126/crosslv/blob/master/screenshots/rg.png)

## Quick Start
```bash
$ sh oneKey.sh
[NAME]
    oneKey.sh -- onekey to setup my working environment
             | - vim | - plugins -- youcompleteme -- supertab -- vim-snippets
                       -- ultisnips -- nerdtree -- auto-pairs -- fzf
                     | - python3 | - etc
             | - tmux | - plugins | - etc

[SYNOPSIS]
    sh oneKey.sh [home | root | help]

[DESCRIPTION]
    home -- build required packages to ~/.usr/
    root -- build required packages to /usr/local/

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, ensure /bin/sh was linked to /bin/bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
                        _
  ___ _ __ ___  ___ ___| |_   __
 / __| '__/ _ \/ __/ __| \ \ / /
| (__| | | (_) \__ \__ \ |\ V /
 \___|_|  \___/|___/___/_| \_/
```
```bash
$ sh oneKey.sh [home | root]
```

## Project Outline
- track-files/  => key files to track on the system, for backup and restore
- oneKey.sh => main 'one key stroke' shell, will auto call
    - makeLink.sh   => additional shell to make link for that in tools/
    - autoHandle.sh => assistant for handling files tracked in confirm/
- tools/    => written for better or understanding some logics
- compile-tools/  => some useful automatically compiling tools, as name indicated
- doc/   => frequently used document
- fonts/ => beautifully and recommended open source fonts
- template/ => some templates generated or used by this project
- testing/  => derived from compile-tools or tools, but deprecated by far
- security/ => derived from doc, but has affairs with sccurity
- vim-colors/ => color schemes for vim use
- completion/ => bash completion for some extra use

## Tip of autoHandle.sh
```bash
# comment on/off one of them to add/remove from tracking
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
$ sh autoHandle.sh
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
    if 'sh $execName' can not be excuted.
    $ ll `which sh`
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    $ ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup tracked files under environment to ${backupDir}/
    track   -> deploy tracked files from 'backup-ed' to ${trackDir}/
    restore -> restore tracked files to environment from ${trackDir}/
    regret  -> regret previous 'restore' action as medicine
    auto    -> run 'backup' & 'track' as pack
    clean   -> clean ${backupDir}.*/, but reserve main backup dir
```

## Modification Note
V3.9
* auto detect OS platform | skipping already installed packages
* correct key parameter of config file adjusting to current system
* add support for MAC system
* .ycm_extra_conf.py adjust c++ include dir/version
* .vimrc adjust python3 interpreter path
* use downloads/ to store all packages wget/clone
* safe to run installation routine many times
* compile newly gcc/c++ version if not support c++ 11
* add number of cpu core check, make -j [cores]
* add YouCompleteMe
* use oneKey.sh replace of some small scripts

V3.1
* use tmux plugin manager for Tmux plugins.
* add tmux-resurrect and update install.sh
* update .tmux.conf and files associated
* reformat function call for some 'case' switch.
* add regret mode for autoHandle script.

V2.1
* for 'backup' mode, add mechanism to check if file to be backuped exists.
* add alias for 'grep'
* change name autoUpdate.sh => autoHandle.sh
* add dry mode and re-format code logic.
* use cat << instead of many echo for this script.

V1.0
* user-friendly manipulate for backup | restore | confirm | clean .

## Reference
[Vundle Introduction Guide](http://www.jianshu.com/p/8d416ac4ad11)

[How Does Cat Eof Work in Bash](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)

[VIM-YouCompleteMe clang+llvm](https://www.jianshu.com/p/c24f919097b3)
