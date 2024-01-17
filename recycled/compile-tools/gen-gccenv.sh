#!/bin/bash
set -x
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0)/../; pwd)
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
                || and write to config

[SYNOPSIS]
    source $exeName [home | root | help]

[DESCRIPTION]
    home -- gcc/c++ was installed in $homeInstDir/
    root -- gcc/c++ was installed in $rootInstDir/
_EOF
    set +x
}

tackleMode() {
    set +x
    #export env variables
    export CC=${commInstdir}/bin/gcc
    export CXX=${commInstdir}/bin/c++
    #export LDFLAGS="-L${commInstdir}/lib -L${commInstdir}/lib64"
    #write to config for further use
    writeFile=$mainWd/gccenv.txt
    cat > $writeFile << _EOF
export CC=${commInstdir}/bin/gcc
export CXX=${commInstdir}/bin/c++
#export LDFLAGS="-L${commInstdir}/lib -L${commInstdir}/lib64"
_EOF
    cat $writeFile
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
