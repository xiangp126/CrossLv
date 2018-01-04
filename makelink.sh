#!/bin/bash

handleDir=tools
mainWd=`pwd`
installDir=~/.usr/bin
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
    cat << _EOF
[NAME]
    $0 -- make linke to $installDir/ from $handleDir/

[USAGE]
    sh $0 [install | uninstall | help]

[DEPENDS]
    make sure $installDir was in PATH

_EOF
}

makeLink() {
    echo mkdir -p $installDir
    mkdir -p $installDir
    
    cd $handleDir
    echo Entering into $handleDir/ ...

    handleFiles=`find . -regex ".*.[sh|py]" -type f`

    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy

        echo Founding tool $realName to make link ...
        echo ln $para ${mainWd}/${handleDir}/${realName} ${installDir}/${linkName}
        ln $para ${mainWd}/${handleDir}/${realName} ${installDir}/${linkName}
    done
    
    cd $mainWd &>/dev/null
    echo Going back to original directory ${mainWd}/ ...
}

rmLink() {
    if [[ ! -d $installDir ]]; then
        echo [Error]: Missing installation $installDir/ ...
        exit
    fi

    cd $handleDir
    echo Entering into $handleDir/ ...

    handleFiles=`find . -regex ".*.sh" -type f`

    for file in ${handleFiles[@]}
    # ./sshproxy.sh
    do
        realName=${file##*/}      # sshproxy.sh
        linkName=${realName%.*}   # sshproxy

        echo "Found tool $realName to remove link ..."
        if [[ ! -f ${installDir}/${linkName} ]]; then
            echo [Warning]: No link name $linkName found, omitting it ...
            continue
        fi
        echo -e "rm ${installDir}/${linkName}"
        rm ${installDir}/${linkName}
    done
    
    cd $mainWd &>/dev/null
    echo Going back to original directory ${mainWd}/ ...
}

case $1 in 
    'install')
        makeLink
    ;;
    
    'uninstall')
        rmLink
    ;;

    *)
        usage
        logo
    ;;

esac

