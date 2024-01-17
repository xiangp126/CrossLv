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

checkOsCpus() {
    if [[ "`which lscpu 2> /dev/null`" == "" ]]; then
        echo [Warning]: OS has no lscpu installed, omitting this ...
        return
    fi
    #set new os cpus
    osCpus=`lscpu | grep -i "^CPU(s):" | tr -s " " | cut -d " " -f 2`
    if [[ "$osCpus" == "" ]]; then
        osCpus=1
    fi
    echo "OS has CPU(S): $osCpus"
}

checkGccVersion() {
    gccLocation=/usr/bin/gcc
    if [[ "$CC" != "" ]]; then
        gccLocation=$CC
    fi
    version=`$gccLocation -dumpversion`
    gccVersion=${version%.*}
    basicVersion=3.0
    echo $gccVersion
    #if gcc < 4.8, exit
    if [[ `echo "$gccVersion >= $basicVersion" | bc` -ne 1 ]]; then
        echo
    fi
}

installCmake() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING CMAKE 3.10 ...
------------------------------------------------------
_EOF
    cmakeInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'python3'
    wgetLink=https://cmake.org/files/v3.10
    tarName=cmake-3.10.1.tar.gz
    untarName=cmake-3.10.1

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
    rm -rf CMakeCache.txt
    # ./configure --prefix=$cmakeInstDir
    ./bootstrap --prefix=$cmakeInstDir

    make -j $osCpus

    # if changing cmake versions between package and source
    hash -r

    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quiting now ...
        exit
    fi
    $execPrefix make install

    cat << _EOF
------------------------------------------------------
INSTALLING cmake 3 DONE ...
`$cmakeInstDir/bin/cmake --version`
cmake path = $cmakeInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
    mkdir -p $downloadPath
    checkOsCpus
    installCmake
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
