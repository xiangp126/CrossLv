# mylx_vundle
my linux programming environment managed by Vundle(for vim plugins) now.

# File List
* autoUpdate.sh: shell for automation of self enviroment setup.
* bashrc.basic: basic .bashrc suitable for all platform.
* confirm: It is a dir, containing the files to be stored.
* trial: test dir for 'sh autoUpdate.sh restore', replace home directory.

# Features
add feature or fix bug for autoUpdate.sh

## V1.0
* user-friendly manipulate for backup | restore | confirm | clean .

# Quick Start
## Install Vndle
better to make dir .vim under home '~' clean.

mv ~/.vim ~/.vim.old may be well.
```bash
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
usage: autoUpdate.sh backup | restore | confirm | clean
backup  -> backup key files under environment to dir: widget
restore -> restore key files to environment from this git repo.
confirm -> confirm to replace key files of this git repo with them under dir: widget.
clean   -> clean dir: widget and subdirs.

> sh autoUpdate.sh restore
missing restore directory, please make it first ...

> mkdir haha
> sh autoUpdate.sh restore
......
------------------------------------------------------
find ./haha -type f
------------------------------------------------------
./haha/.vimrc
./haha/.bashrc
./haha/.vim/bundle/snipMate/snippets/c.snippets
./haha/.vim/bundle/snipMate/snippets/cpp.snippets
./haha/.vim/colors/corsair.vim
./haha/.tmux.conf
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
