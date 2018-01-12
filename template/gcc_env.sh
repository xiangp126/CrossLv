#!/bin/bash
set -x
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode 
commInstdir=$homeInstDir

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- source self-built gcc/c++ env

[SYNOPSIS]
    source $exeName [home | root | help]

[DESCRIPTION]
    home -- gcc/c++ was installed in $homeInstDir/
    root -- gcc/c++ was installed in $rootInstDir/
_EOF
}

tackleMode() {
    export CC=${commInstdir}/bin/gcc
    export CXX=${commInstdir}/bin/c++
    export LDFLAGS="-L${commInstdir}/lib -L${commInstdir}/lib64"
}

case $1 in
    'home')
        commInstdir=$homeInstDir
        tackleMode
    ;;
    'root')
        commInstdir=$rootInstDir
        tackleMode
    ;;
    *)
        set +x
        usage
    ;;
esac
