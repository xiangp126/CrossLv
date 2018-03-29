- This project aims to persist the same programming environment On Linux platform
    - save more time and enjoy more life
    - auto fit for different OS type
    - doen everything for me with 'one-key' stroke
- Project packaged with some awesome open source tools
    - fuzzy-find command-line tool and its vim plugin
    - the language code-completion engine for vim
    - the awsome terminal multiplexer running on server
- And with
    - self-written handy scripts on [tools](https://github.com/xiangp126/crosslv/blob/master/tools) and somewhere else
    - personal dotfiles on [track-files](https://github.com/xiangp126/crosslv/blob/master/track-files)
    - extra bash completion for fzf/tmux/git on [completion](https://github.com/xiangp126/crosslv/blob/master/completion)
    - favourite personal vim color scheme on [darkcoding.vim](https://github.com/xiangp126/crosslv/blob/master/vim-colors/darkcoding.vim)
    - programming font on [monaco.ttf](https://github.com/xiangp126/crosslv/blob/master/fonts/monaco.ttf)
    - etc...
- Two modes deploy selection
    - home mode: without root privilege, normally install packages into $HOME/.usr
    - root mode: with root privilege, normally install packages into /usr/local
- Incremental install supported, safe to run consecutive times
- Has checked on Ubuntu | CentOS | Mac

Catch a glimpse of the effect

![](https://github.com/xiangp126/crosslv/blob/master/gif/crosslv.gif)

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
                     _     _   _
 _ __   ___ _ __ ___(_)___| |_| |_   __
| '_ \ / _ \ '__/ __| / __| __| \ \ / /
| |_) |  __/ |  \__ \ \__ \ |_| |\ V /
| .__/ \___|_|  |___/_|___/\__|_| \_/
|_|

```
```bash
$ sh oneKey.sh [home | root]
```

## Modification Note
V3.9.1
* revise makeLink.sh, skip already linked tool
* fix bug install cmake: check install status, then soft link it if failed
* in practice, ag was better than rg on Vim search, so keep install ag

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

## Tips of key

autoHandle.sh and makeLink.sh was automatically called by oneKey.sh,

however their function can be used outside this project, so separate them alone

- Tips of autoHandle.sh

comment on/off one of them to add/remove from tracking

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

- Tips of makeLink.sh

```bash
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

## Reference
- [HOW DOES CAT EOF WORK IN BASH](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)
- [VIM-YOUCOMPLETEME CLANG+LLVM](https://www.jianshu.com/p/c24f919097b3)
