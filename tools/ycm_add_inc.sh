#!/bin/bash
mainWd=$(cd $(dirname $0); pwd)
startDir=`pwd`
incDir=inc

doJob() {
    if [[ -d "$incDir" ]]; then
        set +x
        echo "Already has inc/, please check it"
        exit 1
    fi

    mkdir -p $incDir
    cd $incDir
    fdPath=`which fd 2> /dev/null`
    if [[ $fdPath != '' ]]; then
        if [[ "$1" == 'nginx' ]]; then
            cmd='fd --type f --no-ignore --exclude inc --exclude win32 '.*\\.h\$' '$startDir
        else
            cmd='fd --type f --no-ignore --exclude inc '.*\\.h\$' '$startDir
        fi
    else
        # use legacy find
        if [[ "$1" == 'nginx' ]]; then
            cmd="find $startDir "'-regex '.*\\.h\$' ! -path '*inc*' ! -path '*win32*''
        else
            cmd="find $startDir "'-regex '.*\\.h\$' ! -path '*inc*''
        fi
    fi

    # make soft link
    for file in `$cmd`; do
        ln -sf $file .
    done

    # copy default ycm config
    cd $startDir
    ycmConf=$HOME/.ycm_extra_conf.py
    if [[ -f "$ycmConf" ]]; then
        if [[ ! -f ".ycm_extra_conf.py" ]]; then
            cp $ycmConf .
        fi
    fi
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- make soft link all headers of current directory
                                       to ./inc/
                -- One Key Done
[USAGE]
    sh $exeName [go | nginx | help]

[EXAMPLE]
    sh $exeName [help]
    sh $exeName go
    sh $exeName nginx

[DESCRIPTION]
    go     start to generate links
    nginx  same as 'go' mode, but special for Nginx source
    help   print help page

_EOF
}

case $1 in
    'nginx')
        set -x
        doJob nginx
        ;;

    'go')
        set -x
        doJob
        ;;

    *)
        set +x
        usage
        ;;
esac
