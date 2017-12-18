#!/bin/bash
# only works for Ubuntu by 15 Dec, 2017.

mytools=(
    "figlet"            
    "tldr"
    "shellcheck"
    "mosh"      # mobile ssh tool
    "htop"
    "iftop"
    "netcat"    # as known as nc
    "bridge-utils"
    "tmux"      # terminal multiplexer
)

mysource=(
    "coreutils"
    "openssh"
    "lsof"
    "netcat-openbsd"
)

exec=apt-get

usage() {
    cat << _EOF
[NAME]
    $0 -- install usefule tools from source-list directly 
        - run this script may need root privilege

[SYNOPSIS] 
    sudo sh $0 [install | remove | help]
_EOF
    cat << "_EOF"

[USAGE]
    $ figlet Hello world
     _   _      _ _        __        __         _     _
     | | | | ___| | | ___   \ \      / /__  _ __| | __| |
     | |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _` |
     |  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |
     |_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_|

     $ shellcheck ~/.bashrc

_EOF
}

doJobInstall() {
    para=$1
    for soft in "${mytools[@]}"
    do
        echo "------------------------------------------------------"
        echo Now "$para" $soft ...
        echo "------------------------------------------------------"
        sudo $exec $para $soft
        echo "$para" $soft done ...
    done
}

doJobSrc() {
    para=$1
    mainPwd=`pwd`

    echo "------------------------------------------------------"
    cdInto=~/.usr/src
    echo mkdir -p $cdInto
    mkdir -p $cdInto
    cd $cdInto
    echo Entering into directory $cdInto ...

    for soft in "${mysource[@]}"
    do
        echo "------------------------------------------------------"
        echo Now Instal Source Code for $soft ...
        echo "------------------------------------------------------"

        $exec $para $soft
        echo "$para" $soft done ...
    done

    cd - &>/dev/null
    echo "------------------------------------------------------"
    echo Go back into main $mainPwd ...
    echo "------------------------------------------------------"

cat << "_EOF"

[EXAMPLE]
    $ dpkg -S `which mv`
    coreutils: /bin/mv
    $ apt-get source coreutils

[LOCATION]
    __                   ___                 _      __
   / /   _ ___ _ __     / / | ___   ___ __ _| |    / /__ _ __ ___
  / / | | / __| '__|   / /| |/ _ \ / __/ _` | |   / / __| '__/ __|
 / /| |_| \__ \ |     / / | | (_) | (_| (_| | |  / /\__ \ | | (__
/_/  \__,_|___/_|    /_/  |_|\___/ \___\__,_|_| /_/ |___/_|  \___|

_EOF
}

parseInput() {
    case "$1" in
        'install')
            doJobInstall install
        ;;

        'remove')
            doJobInstall remove
        ;;

        'source')
            doJobSrc "source"
        ;;

        *)
            usage
        ;;
    esac
}

# begin to parse input.
parseInput $1

