#!/bin/bash
# only works for Ubuntu by 15 Dec, 2017.

mytools=(
    "figlet"            
#    "tldr"
    "xclip"
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

logo() {
    cat << "_EOF"
           _     _ _              _
  __ _  __| | __| | |_ ___   ___ | |___
 / _` |/ _` |/ _` | __/ _ \ / _ \| / __|
| (_| | (_| | (_| | || (_) | (_) | \__ \
 \__,_|\__,_|\__,_|\__\___/ \___/|_|___/

_EOF
}
usage() {
    cat << _EOF
[NAME]
    $0 -- install usefule tools from source-list directly 
        - do not use sudo to run this script

[SYNOPSIS] 
    sh $0 [install | uninstall | source | help]
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

    echo "******************************************************"
    echo "*            SOURCES UNDER ~/.usr/src                *"
    echo "******************************************************"

cat << "_EOF"

[EXAMPLE]
    $ dpkg -S `which mv`
    coreutils: /bin/mv
    $ apt-get source coreutils
_EOF
    logo
}

parseInput() {
    case "$1" in
        'install')
            doJobInstall install
        ;;

        'uninstall')
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

