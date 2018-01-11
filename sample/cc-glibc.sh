#!/bin/bash
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory
mainWd=$startDir

# Glibc install
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
#sudo or empty
execPrefix=""      
#how many cpus os has, used for make -j 
osCpus=1

logo() {
    cat << "_EOF"
      _ _ _
  __ _| (_) |__   ___
 / _` | | | '_ \ / __|
| (_| | | | |_) | (__
 \__, |_|_|_.__/ \___|
 |___/

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup newly glibc 2.15
                || 2.26 too old as GNU ld

[SYNOPSIS]
    $exeName [home | root | help]

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

installGlibc() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING GLIBC ...
------------------------------------------------------
_EOF
    glibcInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'glibc'
    wgetLink=http://mirrors.peers.community/mirrors/gnu/libc
    tarName=glibc-2.15.tar.gz
    untarName=glibc-2.15

    # rename download package if needed
    cd $startDir
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
	echo [Error]: Tar Ball already untared, omitting untar routine ...

    cd $untarName
	# make a separate build directory
	buildir=build_tmp
	mkdir -p $buildir
	cd $buildir
    ../configure --prefix=$glibcInstDir \
                 --disable-sanity-checks
    make -j $osCpus
	# check if make returns successfully
	if [[ $? != 0 ]]; then
		echo [Error]: make returns error, quiting now ...
		exit
	fi

    if [[ "$execPrefix" != "sudo" ]]; then
        echo Not make install with oridinary privilege ...
        `ls -l ./$buildir/libc.so.6`
        exit
    fi

    $execPrefix make install
    #back to start directory
    cd $startDir
    
    cat << _EOF
------------------------------------------------------
INSTALLING GLIBC DONE ...
export LD_LIBRARY_PATH=$glibcInstDir/lib:$glibcInstDir/lib64:$LD_LIBRARY_PATH
export PATH=$glibcInstDir/bin:$PATH
------------------------------------------------------
_EOF
}

install() {
	checkOsCpus
    installGlibc
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
