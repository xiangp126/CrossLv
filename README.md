## Mylx-Vundle
Goal to handle my working environment through one key stroke under Unix like platform 

Auto fix dependency and skipping already installed packages

This tool itself end up with compiling YouCompleteMe done

Two modes deploy selection: home -> without root privilege
                            root -> with root privilege

If needed, compiling GCC and Clang may take up 5G+ disk space

Verified on Ubuntu/CentOS 7 and old version - CentOS 6

## Installation Guide
```bash
$ sh oneKey.sh
[NAME]
    oneKey.sh -- onekey to setup my working environment | - tmux
    | - vim | - vundle -- youcompleteme -- supertab -- vim-snippets
             -- ultisnips -- nerdtree -- auto-pairs
    | - gcc | - python3 | - etc

[SYNOPSIS]
    oneKey.sh [home | root | help]

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*

[DESCRIPTION]
    home -- build required packages to ~/.usr/
    root -- build required packages to /usr/local/
                   _     _
 _ __ ___  _   _  | |   (_)_ __  _   ___  __
| '_ ` _ \| | | | | |   | | '_ \| | | \ \/ /
| | | | | | |_| | | |___| | | | | |_| |>  <
|_| |_| |_|\__, | |_____|_|_| |_|\__,_/_/\_\
           |___/

```

## Features
V3.9
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

## Example for autoHandle.sh
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

# Reference
[Vundle Introduction Guide](http://www.jianshu.com/p/8d416ac4ad11)

[how does cat eof work in bash](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)

[VIM-YouCompleteMe clang+llvm](https://www.jianshu.com/p/c24f919097b3)
