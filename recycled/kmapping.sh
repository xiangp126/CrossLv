#!/bin/bash

usage() {
    exeName=${0##*/}
cat << _EOF
[NAME]
    $exeName -- re-mapping CapsLock to Esc of keyboard

[SYNOPSIS]
    sh $exeName [install | uninstall | help]

[EXAMPLE]
    sh $exeName install
    sh $exeName uninstall

[DESCRIPTION]
    install   - take re-mapping into action
    uninstall - restore re-mapping action

_EOF
}

case $1 in
    'install')
        setxkbmap -option caps:escape
        ;;
    'uninstall')
        setxkbmap -option
        ;;
    *)
        usage
        ;;
esac
