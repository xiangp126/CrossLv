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
    $exeName -- make linke from $handleDir/
                           to   $installDir/ 
[USAGE]
    sh $exeName [install | uninstall | help]

[DEPENDS]
    you should make $installDir/ in PATH

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

    handleFiles=`find . -regex ".*.[sh|py]" -type f -executable`
    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy
        echo Founding tool $realName to make link ...
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
    handleFiles=`find . -regex ".*.[sh|py]" -type f -executable`
    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy

        echo "Found tool $realName to remove link ..."
        if [[ ! -f ${installDir}/${linkName} ]]; then
            echo [Warning]: No linked name $linkName found, omitting it ...
            echo
            continue
        fi
        echo "rm ${installDir}/${linkName}"
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
