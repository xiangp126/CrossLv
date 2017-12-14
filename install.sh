#!/bin/bash
# Copyright by Peng, 2017. xiangp126@sjtu.edu.cn.
# sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
# > ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*

# global parameters.
baseDir=virtual
bkDir=.vim
bkPostfix=old

usage() {
cat << _EOF
[NAME]
    $0 -- auto install Vundle(vim plugin handler)

[USAGE]
    sh $0 dry | root

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

echo mkdir -p $baseDir
mkdir -p $baseDir
# absolute file path.
abPath=${baseDir}/${bkDir}

echo mv ${abPath} ${abPath}.old
# remove .old files before mv overwrite.
rm -rf ${abPath}.$bkPostfix
mv ${abPath} ${abPath}.$bkPostfix 2>/dev/null

cat << _EOF
------------------------------------------------------
Run backup routine now ...
------------------------------------------------------
_EOF
echo sh autoHandle.sh backup
sh autoHandle.sh backup

echo git clone https://github.com/VundleVim/Vundle.vim.git ${abPath}/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ${abPath}/bundle/Vundle.vim

echo Replacing Current ${abPath}/.vimrc with standard version ...
cp ./confirm/_.vimrc ${baseDir}/.vimrc

cat << _EOF
------------------------------------------------------
Please open a vim and excute command
    :source ${abPath}/.vimrc
    :PluginInstall

Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append `!` to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
_EOF

