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
 _____                    _       _
|_   _|__ _ __ ___  _ __ | | __ _| |_ ___
  | |/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
  | |  __/ | | | | | |_) | | (_| | ||  __/
  |_|\___|_| |_| |_| .__/|_|\__,_|\__\___|
                   |_|

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- Template to compile and install certain package

[SYNOPSIS]
    sh $exeName [home | root | help]

[DESCRIPTION]
    home -- install to $homeInstDir/
    root -- install to $rootInstDir/

_EOF
    set +x
    logo
}

checkOsCpus() {
    if [[ "`which lscpu 2> /dev/null`" == "" ]]; then
        echo [Warning]: OS has no lscpu installed, omitting this ...
        osCpus=""
        return
    fi
    #set new os cpus
    osCpus=`lscpu | grep -i "^CPU(s):" | tr -s " " | cut -d " " -f 2`
    if [[ "$osCpus" == "" ]]; then
        osCpus=1
    fi
    echo "OS has CPU(S): $osCpus"
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
    untarName=tcl8.4.19

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

    tclLib=$tclInstDir/lib
    tclIncDir=$tclInstDir/include
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
    ./configure --with-tcl=$tclLib --with-tclinclude=$tclIncDir

    make -j $osCpus

    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quiting now ...
        exit
    fi
    $execPrefix make install
}

install() {
    mkdir -p $downloadPath
    checkOsCpus
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
