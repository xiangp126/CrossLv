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

usage() {
cat << _EOF
[NAME]
    $0 -- auto install Vundle(vim plugin handler)

[USAGE]
    sh $0 [dry | root]

[EXAMPLE]
    sh $0 dry : use $baseDir for dry try.
    sh $0 root: install to ~/
_EOF

}    

case $1 in 
    'dry')
        echo Using default $baseDir/ ...
    ;;

    'root')
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

# absolute file path.
for tdir in ${tackleDir[@]}
do
    abPath=${baseDir}/${tdir}
    
    echo mv ${abPath} ${abPath}.old
    # remove .old files before mv overwrite.
    rm -rf ${abPath}.$bkPostfix
    mv ${abPath} ${abPath}.$bkPostfix 2>/dev/null
done

cat << _EOF
------------------------------------------------------
Run backup routine now ...
------------------------------------------------------
_EOF
echo sh autoHandle.sh backup
sh autoHandle.sh backup

echo "Installing VIM-PLUGIN manager ..."
echo ------------------------------------------------------
echo git clone https://github.com/VundleVim/Vundle.vim.git ${baseDir}/${tackleDir[0]}/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ${baseDir}/${tackleDir[0]}/bundle/Vundle.vim

echo ------------------------------------------------------
echo "Installing TMUX-PLUGIN manager ..."
echo ------------------------------------------------------
git clone https://github.com/tmux-plugins/tpm ${baseDir}/${tackleDir[1]}/plugins/tpm

echo ------------------------------------------------------
echo Replacing CURRENT ${baseDir}/${tackleDir[0]}/.vimrc with STANDARD version ...
echo ------------------------------------------------------
cp ./confirm/_.vimrc ${baseDir}/${tackleDir[0]}/.vimrc

    cat << "_EOF"

------------------------------------------------------
VIM PLUGIN MANAGER INSTRUTION
------------------------------------------------------
__     __  ___   __  __
\ \   / / |_ _| |  \/  |
 \ \ / /   | |  | |\/| |
  \ V /    | |  | |  | |
   \_/    |___| |_|  |_|

# source ~/.vimrc if needed
:PluginInstall
$ sh autoHandle.sh restore

Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append `!` to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

------------------------------------------------------
TMUX PLUGIN MANAGER INSTRUCTION
------------------------------------------------------
 _____   __  __   _   _  __  __
|_   _| |  \/  | | | | | \ \/ /
  | |   | |\/| | | | | |  \  /
  | |   | |  | | | |_| |  /  \
  |_|   |_|  |_|  \___/  /_/\_\

$ tmux
=> Type 'send-prefix + I' (shift + i)

Brief help
    send-prefix + I        # install
    send-prefix + U        # update
    send-prefix + Alt-u    # uninstall plugins not on the plugin list

_EOF

