## lx-Vundle
- Goal to handle working environment crossing different Linux/MAC platform through 'oneKey' stroke
    - fix dependency and skipping already installed packages
    - correct key parameter of config file adjusting to current system

- Three modes deploy selection
    - home -> without root privilege, normally installed into $HOME/.usr
    - root -> with root privilege, normally installed into /usr/local
    - mac  -> 'mac' has some difference with basic Linux, and install to $HOME/.usr

- This tool itself end up with compiling YouCompleteMe done

- On Ubuntu and MacOS whole installation takes little time

- On CentOS 6, too old version gcc and missing clang make compiling them taking huge time
    - however it is still a whole stage automatical solution that is very helpful.

## Installation Guide
```bash
$ sh oneKey.sh
[NAME]
    oneKey.sh -- onekey to setup my working environment | - tmux
             | - vim | - vundle -- youcompleteme -- supertab -- vim-snippets
                      -- ultisnips -- nerdtree -- auto-pairs
             | - gcc | - python3 | - etc

[SYNOPSIS]
    sh oneKey.sh [home | root | mac | help]

[DESCRIPTION]
    home -- build required packages to ~/.usr/
    root -- build required packages to /usr/local/
    mac  -- build required packages to ~/.usr/ on MacOS

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, ensure /bin/sh was linked to /bin/bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
                   _     _
 _ __ ___  _   _  | |   (_)_ __  _   ___  __
| '_ ` _ \| | | | | |   | | '_ \| | | \ \/ /
| | | | | | |_| | | |___| | | | | |_| |>  <
|_| |_| |_|\__, | |_____|_|_| |_|\__,_/_/\_\
           |___/

```
```bash
$ sh oneKey.sh [home | root | mac]
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
- vim-colors/ => color schemes for vim use
- completion/ => bash completion for some extra use

## Example for autoHandle.sh
```bash
$ sh autoHandle.sh
[NAME]
    autoHandle.sh -- auto backup/restore key files of current linux env.

[SYNOPSIS]
    sh autoHandle.sh [backup | restore | track | regret | dry | clean]

[EXAMPLE]
    sh autoHandle.sh backup
    sh autoHandle.sh dry
    sh autoHandle.sh restore
    sh autoHandle.sh track

[TROUBLESHOOTING]
    if 'sh autoHandle.sh' can not be excuted.
    $ ll /bin/sh
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    $ ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ./backup/
    restore -> restore key files to environment from ./track/
    track   -> confirm to copy files in ./backup/ to ./track/
    regret  -> regret previous 'restore' action as medicine
    dry     -> run restore in dry mode, thought ./dry-restore/ as ~/
    clean   -> clean ./backup.*/, but reserve main backup dir
```
```bash
$ sh autoHandle.sh backup
------------------------------------------------------
START TO BACKUP TRACKED FILES ...
------------------------------------------------------
cp ~/.vimrc ./backup/vimrc ...
cp ~/.bashrc ./backup/bashrc ...
cp ~/.tmux.conf ./backup/tmux.conf ...
cp ~/.ycm_extra_conf.py ./backup/ycm_extra_conf.py ...
------------------------------------------------------
FINDING FILES BACKUPED SUCCESSFULLY ...
------------------------------------------------------
./backup/bashrc
./backup/tmux.conf
./backup/vimrc
./backup/ycm_extra_conf.py
------------------------------------------------------
```
```bash
$ sh autoHandle.sh restore
------------------------------------------------------
START TO RESTORE TRACKED FILES ...
------------------------------------------------------
[Warning]: found .vimrc under ~, back it up ...
mv ~/.vimrc ~/.vimrc.old
cp ./track/vimrc ~/.vimrc
[Warning]: found .bashrc under ~, back it up ...
mv ~/.bashrc ~/.bashrc.old
cp ./track/bashrc ~/.bashrc
[Warning]: found .tmux.conf under ~, back it up ...
mv ~/.tmux.conf ~/.tmux.conf.old
cp ./track/tmux.conf ~/.tmux.conf
[Warning]: found .ycm_extra_conf.py under ~, back it up ...
mv ~/.ycm_extra_conf.py ~/.ycm_extra_conf.py.old
cp ./track/ycm_extra_conf.py ~/.ycm_extra_conf.py
------------------------------------------------------
FINDING FILES RESTORED SUCCESSFULLY ...
------------------------------------------------------
~/.vimrc
~/.bashrc
~/.tmux.conf
~/.ycm_extra_conf.py
------------------------------------------------------
START TO COPYING BASH COMPLETION FILES ...
------------------------------------------------------
cp -f ./completion/git-completion.bash ~/.completion.d/
cp -f ./completion/git_flow.completion.bash ~/.completion.d/
cp -f ./completion/git_flow_avh.completion.bash ~/.completion.d/
cp -f ./completion/tmux-completion.bash ~/.completion.d/
------------------------------------------------------
FINDING BASH-COMPLETION SUCCESSFULLY COPIED ...
------------------------------------------------------
~/.completion.d/git-completion.bash
~/.completion.d/git_flow.completion.bash
~/.completion.d/git_flow_avh.completion.bash
~/.completion.d/tmux-completion.bash
------------------------------------------------------
```

## Features
V3.9

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

[how does cat eof work in bash](https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash)

[VIM-YouCompleteMe clang+llvm](https://www.jianshu.com/p/c24f919097b3)
