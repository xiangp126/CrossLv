#!/bin/bash
set -x
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0)/../; pwd)
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
#sudo or empty
execPrefix=""
#how many cpus os has, used for make -j
osCpus=1
# store all downloaded packages here
downloadPath=$mainWd/downloads

logo() {
    cat << "_EOF"
                      _
  ___ _ __ ___   __ _| | _____
 / __| '_ ` _ \ / _` | |/ / _ \
| (__| | | | | | (_| |   <  __/
 \___|_| |_| |_|\__,_|_|\_\___|

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- compile and install newly cmake version

[SYNOPSIS]
    sh $exeName [home | root | help]

[DESCRIPTION]
    home -- install to $homeInstDir/
    root -- install to $rootInstDir/

_EOF
    set +x
    logo
}

installTcl() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING TCL
------------------------------------------------------
_EOF
    tclInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    wgetLink=https://sourceforge.net/projects/tcl/files/Tcl/8.4.19
    tarName=tcl8.4.19-src.tar.gz
    untarName=tcl8.4.19-src.tar.gz

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${tarName}" \
            -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    if [[ ! -d $untarName ]]; then
        tar -zxv -f $tarName
    fi
    cd $untarName
    cd unix
    ./configure --prefix=$tclInstDir

    make -j $osCpus

    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quiting now ...
        exit
    fi
    $execPrefix make install

    cat << _EOF
------------------------------------------------------
INSTALLING tcl DONE ...
tcl path = $tclInstDir/bin/
------------------------------------------------------
_EOF
}

installExpect() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING EXPECT
------------------------------------------------------
_EOF
    expectInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    wgetLink=http://sourceforge.net/projects/expect/files/Expect/5.45
    tarName=expect5.45.tar.gz
    untarName=expect5.45

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${tarName}" \
            -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    if [[ ! -d $untarName ]]; then
        tar -zxv -f $tarName
    fi

    cd $untarName
    ./configure --with-tcl=/usr/local/lib --with-tclinclude=../tcl8.4.19/generic

    make -j $osCpus

    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quiting now ...
        exit
    fi
    $execPrefix make install

    cat << _EOF
------------------------------------------------------
INSTALLING expect 3 DONE ...
expect path = $expectInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
    mkdir -p $downloadPath
    installTcl
    installExpect
}

case $1 in
    'home')
        commInstdir=$homeInstDir
        execPrefix=""
        install
        ;;

    'root')
        commInstdir=$rootInstDir
        execPrefix=sudo
        install
        ;;

    *)
        set +x
        usage
        ;;
esac
