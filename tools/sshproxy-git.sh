#!/bin/bash
# config
# Should be placed at ~/.ssh/config, make it if not exist. 
# or you should edit line at /etc/ssh/ssh_config
# 49 #   ProxyCommand ssh -q -W %h:%p gateway.example.com
# Host *
#   ProxyCommand netcat -x 127.0.0.1:8080 %h %p

logo() {
    cat << "_EOF"
         _
 ___ ___| |__  _ __  _ __ _____  ___   _
/ __/ __| '_ \| '_ \| '__/ _ \ \/ / | | |
\__ \__ \ | | | |_) | | | (_) >  <| |_| |
|___/___/_| |_| .__/|_|  \___/_/\_\\__, |
              |_|                  |___/
_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup git proxy from ssh connection 

[SYNOPSIS]
    sh $exeName [install | uninstall | help]

[DESCRIPTION]
    git push using proxy through SSH reverse tunnel.
    proxy => socks5://127.0.0.1:8080 

[PREREQUISITE]
   pls ensure first: ssh -vv -ND 8080 -l [loginName] [midmanServer]
_EOF

    logo
}

# proxycommand use by ssh command.
pxyCmd='netcat -x 127.0.0.1:8080 %h %p'

if [ $# -le 0 ]; then
    usage
    exit
fi

# config file name.
cfgFile=config
cfgFilePath=~/.ssh/$cfgFile

writeCfg() {
# write contents to config file.
cat << EOF > $1
# config
# Should be placed at ~/.ssh/config, make it if not exist. 
# or you should edit line at /etc/ssh/ssh_config
# 49 #   ProxyCommand ssh -q -W %h:%p gateway.example.com
Host github.com
    Hostname github.com
    ProxyCommand netcat -x 127.0.0.1:8080 %h %p
EOF
}

uninstall() {
    if [ -f $cfgFilePath ]; then
        echo "Found $cfgFile file, Moving $cfgFile to ${cfgFile}.bak"
        cd ~/.ssh
        mv $cfgFile ${cfgFile}.bak
        cd - &>/dev/null
        echo Move Done!
    else 
        echo "Already has no $cfgFilePath, Quiting Now ..."
        exit
    fi
}

install() {
    if [ -f ${cfgFilePath} ]; then
        echo "Found $cfgFile file, backup $cfgFile to ${cfgFile}.bak"
        cd ~/.ssh
        echo mv $cfgFile ${cfgFile}.bak
        mv $cfgFile ${cfgFile}.bak
        cd - &>/dev/null
        echo Backup Done!
    fi

    # pass parameter to the self-defined function.
    echo Writing Contents to config: $cfgFilePath
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
esac;

