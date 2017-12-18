#!/bin/sh

usage() {
    cat << "_EOF"
make linke to 

_EOF
}

para=-sf

mkdir -p ~/.usr/bin
pWd=`pwd`


case $1 in 
    'install')

    ;;
    
'uninstall')


    ;;
esac


echo Establish soft link into ~/.usr/bin ...
echo ln $para ${pWd}/sshproxy.sh ~/.usr/bin/sshproxy
ln $para ${pWd}/sshproxy.sh ~/.usr/bin/sshproxy

echo ln $para ${pWd}/httproxy.sh ~/.usr/bin/httproxy
ln $para ${pWd}/httproxy.sh ~/.usr/bin/httproxy
