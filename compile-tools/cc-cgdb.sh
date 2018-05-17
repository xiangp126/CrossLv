#!/bin/bash
downloadPath=../downloads
homeInstDir=$HOME/.usr/
rootInstDir=/usr/local
commInstdir=$homeInstDir
execPrefix=""

usage() {
    echo "usage: $0 [home | root]"
}

install() {
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
    latestTag=v0.6.8
    if [[ "$latestTag" != "" ]]; then
        git checkout $latestTag
    fi

    sh autogen.sh
    ./configure --prefix=$cgdbInstDir
    make -j
    $execPrefix make install
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
        # create flag for had run more than one time
        commInstdir=$rootInstDir
        execPrefix=sudo
        install
        ;;

    *)
        usage
        exit
        ;;
esac
