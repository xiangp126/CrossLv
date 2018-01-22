## Mylx-Vundle
- Goal to handle working environment crossing different Linux platform through one key stroke 
    - fix dependency and skipping already installed packages
    - correct key parameter of config file adjusting to current system

- Two modes deploy selection
    - home -> without root privilege, normally installed into $HOME/.usr
    - root -> with root privilege, normally installed into /usr/local

- This tool itself end up with compiling YouCompleteMe done

- Verified on Ubuntu/CentOS 7 and old version - CentOS 6

## Installation Guide
```bash
$ sh oneKey.sh
[NAME]
    oneKey.sh -- onekey to setup my working environment | - tmux
             | - vim | - vundle -- youcompleteme -- supertab -- vim-snippets
                      -- ultisnips -- nerdtree -- auto-pairs
             | - gcc | - python3 | - etc

[SYNOPSIS]
    sh oneKey.sh [home | root | help]

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
```bash
$ sh oneKey.sh [home | root]
```

## Project Outline
- confirm/  => key files to track on the system, for backup and restore
- oneKey.sh => main 'one key stroke' shell, will auto call
    - makeLink.sh   => additional shell to make link for that in tools/
    - autoHandle.sh => assistant for handling files tracked in confirm/
- tools/    => written for better or understanding some logics 
    - ./mygit.py
    - ./indexcat.py
    - ./addtools.sh
    - ./mkfonts.sh
    - ./tmuxhelp.sh
    - ./sshjumphost.sh
    - ./fixosdepends.sh
    - ./sshproxy-git.sh
    - ./httproxy-git.sh
- compile-tools/  => some useful automatically compiling tools, as name indicated
    -  ./cc-vim.sh
    -  ./cc-git.sh
    -  ./cc-gcc.sh
    -  ./cc-clang.sh # compiling GCC and Clang may take up 5G+ disk space
    -  ./cc-cmake.sh
    -  ./cc-python3.sh
    -  ./gen-gccenv.sh
- doc/   => frequently used document
- fonts/ => beautifully and recommended open source fonts
- template/ => some templates generated or used by this project
- testing/  => derived from compile-tools or tools, but deprecated by far
- security/ => derived from doc, but has affairs with sccurity
- completion/ => bash completion for some extra use

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
```

``` bash
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
```

``` bash
> sh autoUpdate.sh backup
mkdir -p widget/.vim/colors
mkdir -p widget/.vim/bundle/snipMate/snippets
Backup /home/virl/./.vimrc to widget/./_.vimrc ...
Backup /home/virl/./.bashrc to widget/./_.bashrc ...
Backup /home/virl/./.tmux.conf to widget/./_.tmux.conf ...
......
```

``` bash
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

## Features
V3.9

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

[how does cat eof work in bash](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)

[VIM-YouCompleteMe clang+llvm](https://www.jianshu.com/p/c24f919097b3)
