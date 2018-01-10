#!/bin/bash
# After this config, git push can be done by username:password,
# but no ssh-key.

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup http/https proxy for git (clone)

[SYNOPSIS]
    sh $exeName [install | uninstall | help]

[DESCRIPTION]
    git clone using proxy through SSH reverse tunnel.
    proxy => socks5://127.0.0.1:8080 

[PREREQUISITE]
   pls ensure first: ssh -vv -ND 8080 -l [loginName] [midmanServer]
_EOF
}

proxyAddr="socks5://127.0.0.1:8080"

if [ $# -le 0 ]; then
    usage
    exit
fi

# Only git did not need below 2 variables.
# With these 2, did not need git config http.proxy.
# export http_proxy=socks5://127.0.0.1:8080
# export https_proxy=socks5://127.0.0.1:8080

case $1 in
    'install')
        echo "start enabling http.proxy ..."
        git config --global http.proxy ${proxyAddr}
        echo "start enabling https.proxy ..."
        git config --global https.proxy ${proxyAddr}
    ;;

    'uninstall')
        echo "start disabling http.proxy ..."
        git config --global --unset http.proxy
        echo "start disabling https.proxy ..."
        git config --global --unset https.proxy
    ;;
esac;

echo "> git config --global --list | grep -i proxy"
git config --global --list | grep -i proxy

echo -e "\n-----------------------------------------"
echo -e 'At last echo $http_proxy and $https_proxy'
echo -e "-----------------------------------------"
echo http_proxy  = $http_proxy
echo https_proxy = $https_proxy
