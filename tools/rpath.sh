#!/bin/bash
# calculate real(absolutely) path of argument 'command'
# set -x

usage() {
    exeName=${0##*/}
cat << _EOF
[NAME]
    $exeName -- calculate real path of argument

[SYNOPSIS]
    sh $exeName [ARG]

[EXAMPLE]
    sh $exeName fkgit.py
    sh $exeName ./fkgit.py
    sh $exeName ../oneKey.sh

_EOF
}

calculate() {
    startDir=`pwd`    # /opt/crosslv/tools/
    para=$1           # ../oneKey.sh
    # fix issue for directory input
    if [[ -d $para ]]; then
        echo $(cd $para; pwd)
        exit
    fi
    fileName=$(basename $para)  # oneKey.sh
    relativeFilePath=${para%/*} # ..

    # fix issue of rpath fkgit.py
    ret=$(echo $1 | grep -i '/' 2> /dev/null)
    if [[ "$ret" == "" ]]; then
        relativeFilePath=.
    fi
    truePath=$(cd $relativeFilePath; pwd) # /opt/crosslv
    echo $truePath/$fileName
    # common install dir for home | root mode
}

case $1 in
    '')
        usage
        ;;
    *)
        calculate $1
        ;;
esac
