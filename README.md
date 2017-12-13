# mylx_vundle
my linux programming environment managed by Vundle(for vim plugins) now.

# File List
* autoUpdate.sh: shell for automation of self enviroment setup.
* _.bashrc: basic .bashrc suitable for all platform.
* confirm/: containing the files to be stored.
* widget/: dir to backup key files of this linux environment.
* trial/: test dir for restore mode, dry mode.

# Features
add feature or fix bug for autoUpdate.sh

V2.1
* for 'backup' mode, add mechanism to check if file to be backuped exists.
* add alias for 'grep'
* change name autoUpdate.sh => autoHandle.sh

V2.0
* add dry mode and re-format code logic.
* use cat << instead of many echo for this script.

V1.0
* user-friendly manipulate for backup | restore | confirm | clean .

# Quick Start
## Install Vndle
better to make dir .vim under home '~' clean.

```bash
> mv ~/.vim ~/.vim.old
# it will make '~/.vim' if it not exist.
> git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
## Setup Plugins
```bash
# replace .vimrc with it from this git repository.
> sh autoUpdate.sh restore
...

> vim
# source .vimrc first.
:source ~/.vimrc
:PluginInstall
:PluginList
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
> sh autoUpdate.sh
[NAME]
    autoUpdate.sh -- auto backup/restore key files of my linux env.

[SYNOPSIS]
    sh autoUpdate.sh backup | dry | restore | confirm | clean

[EXAMPLE]
    sh autoUpdate.sh backup
    sh autoUpdate.sh dry
    sh autoUpdate.sh restore

[TROUBLESHOOTING]
    # sh autoUpdate.sh can not be excuted.
    > ll /bin/sh
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    > ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ./widget/
    dry     -> run restore in dry mode, thought trial/ as ~/
    restore -> restore key files to environment from ./confirm/
    confirm -> confirm to copy files in ./widget/ to ./confirm/
    clean   -> clean ./widget.*/, but reserve main backup dir

> sh autoUpdate.sh restore
missing restore directory, please make it first ...

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
