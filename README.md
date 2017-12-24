# mylx_vundle
easily setup my working environment through some small scripts.

use plugins manager for VIM and TMUX

# Installation Guide
verified on MacOS | Ubuntu | CentOS

```bash
$ sh install.sh
[NAME]
    install.sh -- auto install plugin managers (vim & tmux)

[USAGE]
    sh install.sh [dry | home | home]

[EXAMPLE]
    sh install.sh dry : use dry_install for dry try.
    sh install.sh home: install to ~/
                   _     _
 _ __ ___  _   _  | |   (_)_ __  _   ___  __
| '_ ` _ \| | | | | |   | | '_ \| | | \ \/ /
| | | | | | |_| | | |___| | | | | |_| |>  <
|_| |_| |_|\__, | |_____|_|_| |_|\__,_/_/\_\
           |___/

$ sh install.sh home

# File List
* install.sh: key install script for bundle-managers.
* autoUpdate.sh: automation of programming enviroment setup.
* confirm/: standard files contained to be restored.
* _.bashrc: basic .bashrc suitable for all platform.
* tools/: some useful scripts for auto set up env. 
```

# Guide
## Backup First
```bash
> mv ~/.vim ~/.vim.old
> sh autoUpdate.sh backup
```

## Install Vndle
```bash
# will make new '~/.vim/' if it not exist.
> git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## Replace Configurations
```bash
# replace key files like .vimrc with them under confirm/
> mv confirm/_.vimrc ~/.vim/.vimrc
```

## Setup Plugins
```bash
------------------------------------------------------
Please open a vim and excute command
    :source haha/.vim/.vimrc
    :PluginInstall

Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append  to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append  to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append  to auto-approve removal

-------------------------------------------------
" My Plugins                               |  1
Plugin 'VundleVim/Vundle.vim'              |~
Plugin 'L9'                                |~
Plugin 'The-NERD-tree'                     |~
Plugin 'Tagbar'                            |~
Plugin 'OmniCppComplete'                   |~
Plugin 'snipMate' 

```

# Usage
```bash
> sh autoHandle.sh
[NAME]
    autoHandle.sh -- auto backup/restore key files of my linux env.

[SYNOPSIS]
    sh autoHandle.sh backup | dry | restore | regret | confirm | clean

[EXAMPLE]
    sh autoHandle.sh backup
    sh autoHandle.sh dry
    sh autoHandle.sh restore

[TROUBLESHOOTING]
    # sh autoHandle.sh can not be excuted.
    > ll /bin/sh
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    > ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ./widget/
    dry     -> run restore in dry mode, thought trial/ as ~/
    restore -> restore key files to environment from ./confirm/
    regret  -> regret previous 'restore'/'dry' action.
    confirm -> confirm to copy files in ./widget/ to ./confirm/
    clean   -> clean ./widget.*/, but reserve main backup dir

> sh autoUpdate.sh restore
missing restore directory, please check it first ...

> mkdir haha
> sh autoUpdate.sh restore
......
------------------------------------------------------
Finding Files Copied Successfully ...
------------------------------------------------------
./trial/./.vimrc
./trial/./.bashrc
./trial/./.tmux.conf
./trial/./.vim/colors/corsair.vim
./trial/./.vim/bundle/snipMate/snippets/c.snippets
./trial/./.vim/bundle/snipMate/snippets/cpp.snippets
------------------------------------------------------

> sh autoUpdate.sh backup
mkdir -p widget/.vim/colors
mkdir -p widget/.vim/bundle/snipMate/snippets
Backup /home/virl/./.vimrc to widget/./_.vimrc ...
Backup /home/virl/./.bashrc to widget/./_.bashrc ...
Backup /home/virl/./.tmux.conf to widget/./_.tmux.conf ...
......

> sh autoUpdate.sh confirm
start to copying files from widget to ./confirm ...
------------------------------------------------------
find ./confirm -type f
------------------------------------------------------
./confirm/_.bashrc
./confirm/_.vimrc
./confirm/_corsair.vim
./confirm/_cpp.snippets
./confirm/_c.snippets
./confirm/_.tmux.conf
------------------------------------------------------

```

# Features

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

# Reference
[Vundle Introduction Guide](http://www.jianshu.com/p/8d416ac4ad11)
[how dows cat eof work in bash](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)

