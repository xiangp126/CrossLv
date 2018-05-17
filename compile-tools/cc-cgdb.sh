#!/bin/bash
# From which path it was executed
startDir=`pwd`
# Absolute path of this shell, no impact by start dir
mainWd=$(cd $(dirname $0)/../; pwd)
downloadPath=$mainWd/downloads
homeInstDir=$HOME/.usr/
rootInstDir=/usr/local
commInstdir=$homeInstDir
execPrefix=""

usage() {
    echo "usage: $0 [home | root]"
}

installCgdb() {
    cat << _EOF
------------------------------------------------------
INSTALLING CGDB INTO $commInstdir
------------------------------------------------------
_EOF
    clonedName=cgdb
    clonedPath=https://github.com/cgdb/cgdb
    cgdbInstDir=$commInstdir

    cd $downloadPath
    if [[ ! -d "$downloadPath" ]]; then
        mkdir -p $downloadPath
    fi
    if [[ ! -d $clonedName ]]; then
        git clone $clonedPath $clonedName
    fi

    cd $clonedName
    # checkout to latest released tag
    git pull
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    # latestTag=v0.6.8
    if [[ "$latestTag" != "" ]]; then
        git checkout $latestTag
    fi

    sh autogen.sh
    ./configure --prefix=$cgdbInstDir
    make -j
    if [[ $? != 0 ]]; then
        echo [Error]: make error, pls check
        exit
    fi
    $execPrefix make install
    if [[ $? != 0 ]]; then
        echo [Error]: make install error, pls check
        exit
    fi
    cgdbPath=$cgdbInstDir/bin/cgdb
}

installRc() {
    cat << "_EOF"
------------------------------------------------------
INSTALLING CGDB RC FILE
------------------------------------------------------
_EOF
    rcFromPath=$mainWd/template/cgdbrc
    rcToPath=$HOME/.cgdb
    cgdbRcPath=$rcToPath/cgdbrc
    if [[ -f $cgdbRcPath ]]; then
        echo [Warning]: already has cgdbrc, cover it anyway
    fi
    $execPrefix cp $rcFromPath $rcToPath

    if [[ $? != 0 ]]; then
        echo [Error]: copy cgdbrc error, please check
        exit
    fi
}

installSummary() {
    cat << _EOF
------------------------------------------------------
INSTALLATION SUMMARY FOR CGDB
------------------------------------------------------
cgdbPath=$cgdbPath
cgdbRcPath=$cgdbRcPath
------------------------------------------------------
_EOF

}

install() {
    installCgdb
    installRc
    installSummary
}

case $1 in
    'home')
        set -x
        commInstdir=$homeInstDir
        execPrefix=""
        install
        ;;

    'root')
        set -x
        commInstdir=$rootInstDir
        execPrefix=sudo
        install
        ;;

    *)
        usage
        exit
        ;;
esac
