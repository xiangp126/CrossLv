#!/bin/bash
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0); pwd)
# dir to handle from and linking to
handleDir=$mainWd/tools
installDir=$HOME/.usr/bin
# link parameter
para=-sf

logo() {
    cat << "_EOF"
                 _          _ _       _
 _ __ ___   __ _| | _____  | (_)_ __ | | __
| '_ ` _ \ / _` | |/ / _ \ | | | '_ \| |/ /
| | | | | | (_| |   <  __/ | | | | | |   <
|_| |_| |_|\__,_|_|\_\___| |_|_|_| |_|_|\_\

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- make link from $handleDir/
                          to   $installDir/
[USAGE]
    sh $exeName [install | uninstall | help]

[EXAMPLE]
    sh $exeName
    sh $exeName install

[TROUBLESHOOTING]
    $installDir/ should be placed in PATH

_EOF
}

makeLink() {
    mkdir -p $installDir
    cd $handleDir
    cat << _EOF
------------------------------------------------------
ENTERING INTO $handleDir/
------------------------------------------------------
_EOF
    # find on macos did not support -executable
    if [[ `uname -s` == "Darwin" ]]; then
        # use fd on mac if possible
        fdPath=`which fd 2> /dev/null`
        if [[ "$fdPath" != "" ]]; then
            handleFiles=`fd -e sh -e py`
        else
            handleFiles=`find . -regex ".*.[sh|py]$" -type f`
        fi
    else
        handleFiles=`find . -regex ".*.[sh|py]$" -type f -executable`
    fi
    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy
        if [[ -f "$installDir/$linkName" ]]; then
            echo [Warning]: tool $realName already linked
            continue
        else
            echo Founding tool $realName to make link ...
        fi
        # show message
        cat << _EOF
ln $para $handleDir/$realName
            to ${installDir}/${linkName}

_EOF
        ln $para $handleDir/$realName ${installDir}/${linkName}
    done
}

rmLink() {
    if [[ ! -d $installDir ]]; then
        echo [Error]: Missing installation $installDir/ ...
        exit
    fi
    cd $handleDir
    cat << _EOF
------------------------------------------------------
ENTERING INTO $handleDir/
------------------------------------------------------
_EOF
    if [[ `uname -s` == "Darwin" ]]; then
        # use fd on mac if possible
        fdPath=`which fd 2> /dev/null`
        if [[ "$fdPath" != "" ]]; then
            handleFiles=`fd -e sh -e py`
        else
            handleFiles=`find . -regex ".*.[sh|py]$" -type f`
        fi
    else
        handleFiles=`find . -regex ".*.[sh|py]$" -type f -executable`
    fi

    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy

        if [[ ! -f ${installDir}/${linkName} ]]; then
            echo [Warning]: No linked name $linkName found, omitting it ...
            continue
        fi
        echo "Found tool $realName to remove link ..."
        echo "        rm ${installDir}/${linkName}"
        rm ${installDir}/${linkName}
        echo
    done
}

case $1 in
    'install')
        makeLink
        exit 0
        ;;

    'uninstall')
        rmLink
        exit 0
        ;;

    *)
        usage
        logo
        exit 0
        ;;
esac
