#!/bin/bash
# config
# Should be placed at ~/.ssh/config, make it if not exist. 
# or you should edit line at /etc/ssh/ssh_config
# 49 #   ProxyCommand ssh -q -W %h:%p gateway.example.com
# Host *
#   ProxyCommand netcat -x 127.0.0.1:8080 %h %p

logo() {
    cat << "_EOF"
         _      _
 ___ ___| |__  (_)_   _ _ __ ___  _ __
/ __/ __| '_ \ | | | | | '_ ` _ \| '_ \
\__ \__ \ | | || | |_| | | | | | | |_) |
|___/___/_| |_|/ |\__,_|_| |_| |_| .__/
             |__/                |_|

_EOF
}

usage() {
    exeName=${0##*/}
cat << _EOF
[NAME]
    $exeName -- setup config file for ssh from client directly to dst-server

[SYNOPSIS]
    sh $exeName [install | uninstall | help]

[DESCRIPTION]
    client =============> jump-server =============> dst-server
       |                                                  ^
       |                                                  |
       |-------------------- X --------------- X ----------
                          
[MANUAL]
    ssh -vv -o ProxyCommand="ssh -W %h:%p login@jump-server" login@dst-server
_EOF

    logo
}

# config file name.
cfgFile=config
cfgFilePath=~/.ssh/$cfgFile

jumpHost="sha-srg-edit7"
# below names can be DNS lookup on jumpHostt
dstServer=(
    "sjc-marsbu-010"
    "sjc-marsbu-011"
    "sjc-marsbu-012"
    "sjc-marsbu-013"
    "sjc-marsbu-014"
    "sjc-marsbu-019"
)
# ssh port of jumpHost
jHostPort=22

# write contents to config file.
writeCfg() {
    # use >> $1 instead of > $1.
    cat << _EOF >> $1
# Host server
#     Hostname server.example.org
#     ProxyCommand ssh jumphost.example.org -W %h:%p
_EOF
    # loop to write config for each server
    for server in ${dstServer[@]}
    do
        # abbreviate name for dstServer
        abbreName=$server
        cat << _EOF >> $1
Host $abbreName
    Hostname $server
    ProxyCommand ssh -p $jHostPort $jumpHost -W %h:%p
_EOF
    done
}

uninstall() {
    if [ -f $cfgFilePath ]; then
        echo "Found $cfgFile file, Moving $cfgFile to ${cfgFile}.bak"

        cd ~/.ssh
        echo Entering into $(pwd) ...
        mv $cfgFile ${cfgFile}.bak

        cd - &>/dev/null
        echo Move Done!
        echo Going back to main $(pwd)/ ...
    else 
        echo "Already has no $cfgFilePath, Quiting Now ..."
        exit
    fi
}

install() {
    if [ -f ${cfgFilePath} ]; then
        echo "Found $cfgFile file, backup $cfgFile to ${cfgFile}.bak"

        cd ~/.ssh
        echo Entering into $(pwd)/ ...
        echo mv $cfgFile ${cfgFile}.bak
        mv $cfgFile ${cfgFile}.bak

        cd - &>/dev/null
        echo Backup Done!
        echo Going back to main $(pwd)/ ...
    fi

    # pass parameter to the self-defined function.
    echo Writing Contents to config: $cfgFilePath ...
    writeCfg $cfgFilePath
    
    echo "cat ~/.ssh/$cfgFile"
    echo "--------------------------------------------------"
    cat ~/.ssh/$cfgFile
}

case $1 in
    'install')
        install
    ;;

    'uninstall')
        uninstall
    ;;

    *)
        usage
    ;;

esac
