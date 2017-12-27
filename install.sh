#!/bin/bash
# Copyright by Peng, 2017. xiangp126@sjtu.edu.cn.
# sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
# > ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*

# global parameters.
baseDir=dry_install
tackleDir=(
    ".vim"
    ".tmux"
)
bkPostfix=old

logo() {
    cat << "_EOF"
                   _     _
 _ __ ___  _   _  | |   (_)_ __  _   ___  __
| '_ ` _ \| | | | | |   | | '_ \| | | \ \/ /
| | | | | | |_| | | |___| | | | | |_| |>  <
|_| |_| |_|\__, | |_____|_|_| |_|\__,_/_/\_\
           |___/

_EOF
}

usage() {
cat << _EOF
[NAME]
    $0 -- auto install plugin managers (vim & tmux)

[USAGE]
    sh $0 [dry | home | help]

[EXAMPLE]
    sh $0 dry : use $baseDir for dry try.
    sh $0 home: install to ~/
_EOF

    logo
}    

case $1 in 
    'dry')
        echo Using default $baseDir/ ...
    ;;

    'home')
        baseDir=~
    ;;

    *)
        usage
        exit
    ;;

esac

if [ ! -d $baseDir ]; then
    echo mkdir -p $baseDir
    mkdir -p $baseDir

fi

# run backup first of all.
cat << _EOF
------------------------------------------------------
Run backup routine first of all now ...
sh autoHandle.sh backup
------------------------------------------------------
_EOF
sh autoHandle.sh backup

# absolute file path.
cat << _EOF

------------------------------------------------------
Moving old Dir to Dir.$bkPostfix ...
------------------------------------------------------
_EOF
for tdir in "${tackleDir[@]}"
do
    abPath=${baseDir}/${tdir}
    
    echo mv ${abPath} ${abPath}.old
    # remove .old files before mv overwrite.
    rm -rf ${abPath}.$bkPostfix
    mv ${abPath} ${abPath}.$bkPostfix 2>/dev/null
done

cat << "_EOF"

------------------------------------------------------
"Installing VIM-PLUGIN manager ..."
------------------------------------------------------
_EOF
echo git clone https://github.com/VundleVim/Vundle.vim.git ${baseDir}/${tackleDir[0]}/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ${baseDir}/${tackleDir[0]}/bundle/Vundle.vim

cat << "_EOF"

------------------------------------------------------
"Installing TMUX-PLUGIN manager ..."
_EOF
echo ------------------------------------------------------
git clone https://github.com/tmux-plugins/tpm ${baseDir}/${tackleDir[1]}/plugins/tpm

cat << _EOF
------------------------------------------------------
Replacing some key files first ...
------------------------------------------------------
_EOF
echo cp -f ./confirm/_.vimrc ${baseDir}/.vimrc
cp -f ./confirm/_.vimrc ${baseDir}/.vimrc
# replace corsair.vim ahead of whole restore
echo mkdir -p ${baseDir}/${tackleDir[0]}/colors
mkdir -p ${baseDir}/${tackleDir[0]}/colors
echo cp -f ./confirm/_corsair.vim ${baseDir}/${tackleDir[0]}/colors/corsair.vim
cp -f ./confirm/_corsair.vim ${baseDir}/${tackleDir[0]}/colors/corsair.vim

cat << "_EOF"

******************************************************
*    NEED YOU DO MANUALLY  --  COPYRIGHT BY PENG     *
******************************************************
------------------------------------------------------
STEP 1 -- VIM PLUGIN MANAGER INSTRUTION
------------------------------------------------------
__     __  ___   __  __
\ \   / / |_ _| |  \/  |
 \ \ / /   | |  | |\/| |
  \ V /    | |  | |  | |
   \_/    |___| |_|  |_|

# source ~/.vimrc if needed
$ vim
:PluginInstall
$ sh autoHandle.sh restore

Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append `!` to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

------------------------------------------------------
STEP 2 -- TMUX PLUGIN MANAGER INSTRUCTION
------------------------------------------------------
 _____   __  __   _   _  __  __
|_   _| |  \/  | | | | | \ \/ /
  | |   | |\/| | | | | |  \  /
  | |   | |  | | | |_| |  /  \
  |_|   |_|  |_|  \___/  /_/\_\

$ tmux
=> Type 'send-prefix + I' (shift + i)

TMUX environment reloaded.
Done, press ENTER to continue.

Brief help
    send-prefix + I        # install
    send-prefix + U        # update
    send-prefix + Alt-u    # uninstall plugins not on the plugin list

_EOF
