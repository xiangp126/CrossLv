#!/bin/bash
set -x
myGccDir=/usr/local/bin
sysGccDir=/usr/bin/

startDir=`pwd`
mainWd=$startDir
#backup suffix
bksuffix=sys

usage() {
	exeName=${0##*/}
	cat << _EOF
[NAME]
    $exeName -- link/unlink of self-compiled gcc to system gcc location

[SYNOPSIS]
    $exeName [link | unlink | help]

[DESCRIPTION]
    link gcc/g++ from $myGccDir to $sysGccDir
    || need root privilege

_EOF
}

case $1 in
    'link' )
        cd $sysGccDir
        #gcc-sys
        sudo mv gcc gcc-$bksuffix
        sudo mv g++ g++-$bksuffix
        sudo ln -s $myGccDir/gcc gcc
        sudo ln -s $myGccDir/g++ g++
    ;;

    'unlink' )
        cd $sysGccDir
        sudo mv gcc-$bksuffix gcc
        sudo mv g++-$bksuffix g++
    ;;

    *)
        usage
    ;;
esac
