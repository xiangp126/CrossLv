#!/bin/bash
# set -x

usage() {
    exeName=${0##*/}
cat << _EOF
[NAME]
    $exeName -- print content of vim buffer file

[SYNOPSIS]
    sh $exeName

[DESCRIPTION]
    vim buffer file is /tmp/pvim.txt now

_EOF
}

pVimBufferFile() {
    vimBufferFile=/tmp/pvim.txt
    if [[ -f $vimBufferFile ]]; then
        cat $vimBufferFile 2> /dev/null
    else
        echo [FatalError]: missing vim buffer file $vimBufferFile
        exit
    fi
}

case $1 in
    '')
        pVimBufferFile
        ;;
    'help')
        usage
        ;;
esac
