#!/bin/bash
# calculate real(absolutely) path of argument 'command'
# very plain, need update later
# set -x

usage() {
    exeName=${0##*/}
cat << _EOF
[NAME]
    $exeName -- calculate real path of argument

[SYNOPSIS]
    sh $exeName [ARG]

[EXAMPLE]
    sh $exeName ./fkgit.py

_EOF
}

calculate() {
    startDir=`pwd`
    # main work directory, not influenced by start dir
    mainWd=$(cd $(dirname $0); pwd)
    commandName=$(basename $1)
    echo $startDir/$commandName
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
