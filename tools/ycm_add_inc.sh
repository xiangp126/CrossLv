#!/bin/bash
set -x
mainWd=$(cd $(dirname $0); pwd)
startDir=`pwd`
incDir=inc

doJob() {
    if [[ -d "$incDir" ]]; then
        echo "Already has directory inc, please check it"
        rm -rf $incDir
        # exit
    fi

    mkdir -p $incDir
    cd $incDir

    fdPath=`which fd 2> /dev/null`

        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --no-ignore --exclude '.git'\
                    --exclude '*.sw[p|o]' --exclude '*.[a|o]' --exclude '*.so'"

    if [[ $fdPath != '' ]]; then
        if [[ "$1" == 'nginx' ]]; then
            cmd='fd --type f --no-ignore --exclude inc --exclude win32 '.*\.h\$' '$startDir
        else
            cmd='fd --type f --no-ignore --exclude inc '.*\.h\$' '$startDir
        fi
    else
        # use legacy find
        if [[ "$1" == 'nginx' ]]; then
            cmd='find $startDir -regex '.*.h$' ! -path '*inc*' ! -path '*win32*''
        else
            cmd='find $startDir -regex '.*.h$' ! -path '*inc*''
        fi
    fi

    # make soft link
    for file in `$cmd`; do
        ln -sf $file .
    done

    # copy default ycm config
    cd $startDir
    ycmConf=$HOME/.ycm_extra_conf.py
    if [[ ! -f "$ycmConf" ]]; then
        cp $ycmConf .
    fi
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- make soft link all headers of current directory to ./inc/

[USAGE]
    sh $exeName [nginx | help]

[EXAMPLE]
    sh $exeName
    sh $exeName nginx --> only for generating Nginx source code

_EOF
}

case $1 in
    'nginx')
        doJob nginx
        ;;

    'help')
        usage
        ;;

    *)
        doJob
        ;;
esac
