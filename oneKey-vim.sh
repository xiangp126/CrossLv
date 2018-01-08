#!/bin/bash
set -x

# this shell start dir, normally original path
startDir=`pwd`
# main work directory, usually ~/myGit
mainWd=$startDir

# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
execPrefix=""
# VIM install

logo() {
    cat << "_EOF"
__     _____ __  __
\ \   / /_ _|  \/  |
 \ \ / / | || |\/| |
  \ V /  | || |  | |
   \_/  |___|_|  |_|

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup newly Vim through one script

[SYNOPSIS]
    $exeName [home | root | help]

[DESCRIPTION]
    home -- install to $homeInstDir/
    root -- install to $rootInstDir/

_EOF
	logo
}

installVim() {
    cat << "_EOF"
    
------------------------------------------------------
STEP : INSTALLING VIM ...
------------------------------------------------------
_EOF
    vimInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'vim'
    vimClonePath=https://github.com/vim/vim
    clonedName=vim
    checkoutVersion=v8.0.1428

    # rename download package
    cd $startDir
    # check if already has this tar ball.
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName/ already exists, Omitting now ...
    else
        git clone ${vimClonePath} $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now ...
            exit
        fi
    fi

    cd $clonedName
    # checkout to v2.15.0
    git checkout $checkoutVersion
    # run make routine
    ./configure --prefix=$vimInstDir --enable-pythoninterp=yes --enable-python3interp=yes
    make -j
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now ...
        exit
    fi

    $execPrefix make install

    cat << "_EOF"
------------------------------------------------------
Installing Git Completion Bash To Home ...
------------------------------------------------------
_EOF
    cd $startDir

    cat << _EOF
    
------------------------------------------------------
INSTALLING VIM DONE ...
`$vimInstDir/bin/vim --version`
vim path = $vimInstDir/bin/
------------------------------------------------------
_EOF
}

# compile YCM if plugin already cloned.
compileYCM() {
    ycmDir=~/.vim/bundle/YouCompleteMe
    if [[ ! -d $ycmDir ]]; then
        echo [Warning]: has no YCM installed, quitting now ...
        return
    fi
    cat << "_EOF"
    
------------------------------------------------------
STEP : COMPILING YCM ...
------------------------------------------------------
_EOF

    cd $ycmDir
    ./install.sh --clang-completer
    # check if install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: install fails, quitting now ...
        exit
    fi

    cat << "_EOF"
------------------------------------------------------
Installing .ycm_extra_conf.py To Home ...
------------------------------------------------------
_EOF
    cd $startDir
    sampleDir=./sample
    sampleFile=ycm_extra_conf.py

    echo cp ${sampleDir}/$sampleFile ~/.$sampleFile
    cp ${sampleDir}/$sampleFile ~/.$sampleFile

    cat << _EOF
    
------------------------------------------------------
INSTALLING YCM DONE ...
------------------------------------------------------
_EOF
}

install() {
    installVim
    compileYCM
}

case $1 in
    'home')
        commInstdir=$homeInstDir
        execPrefix=""
        install
    ;;

    'root')
        commInstdir=$rootInstDir
        execPrefix=sudo
        install
    ;;

    *)
        set +x
        usage
    ;;
esac
