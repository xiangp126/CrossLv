#!/bin/bash
# set -x
tmuxBufferFile=/tmp/tvim.txt

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- print content of tmux buffer file

[SYNOPSIS]
    sh $exeName

[DESCRIPTION]
    tmux buffer file is $tmuxBufferFile now

_EOF
}

pTmuxBufferFile() {
    tmuxPath=`which tmux 2> /dev/null`
    if [[ "$tmuxPath" != "" ]]; then
        tmux save-buffer - > $tmuxBufferFile
        gedit $tmuxBufferFile
    else
        echo [FatalError]: Your system has no tmux installed, check it first
        exit
    fi
}

case $1 in
    '')
        pTmuxBufferFile
        ;;
    'help')
        usage
        ;;
esac
