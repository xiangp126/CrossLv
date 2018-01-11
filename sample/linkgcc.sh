#!/bin/bash
set -x
myGccDir=/usr/local/bin
sysGccDir=/usr/bin/

startDir=`pwd`
mainWd=$startDir
#file gcc/c++
#backup suffix
bksuffix=sys

if [[ ! -f "$myGccDir/gcc" ]]; then
    echo no gcc under $myGccDir, exit now ...
    exit
fi
if [[ ! -f "$myGccDir/c++" ]]; then
    echo no c++ under $myGccDir, exit now ...
    exit
fi

usage() {
	exeName=${0##*/}
	cat << _EOF
[NAME]
    $exeName -- link/unlink of self-compiled gcc to system gcc location

[SYNOPSIS]
    $exeName [link | unlink | help]

[DESCRIPTION]
    link gcc/c++ from $myGccDir to $sysGccDir
    || need root privilege

_EOF
}

case $1 in
    'link' )
        cd $sysGccDir
        #gcc-sys
        sudo mv gcc gcc-$bksuffix
        sudo mv c++ c++-$bksuffix
        sudo ln -s $myGccDir/gcc gcc
        sudo ln -s $myGccDir/c++ c++
    ;;

    'unlink' )
        cd $sysGccDir
        sudo mv gcc-$bksuffix gcc
        sudo mv c++-$bksuffix c++
    ;;

    *)
        usage
    ;;
esac
