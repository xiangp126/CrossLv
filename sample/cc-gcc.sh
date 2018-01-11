#!/bin/bash
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory
mainWd=$startDir

# Gcc install
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
             _   _
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup newly python3 

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

installGcc() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING GCC5 ...
------------------------------------------------------
_EOF
    gccInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'gcc'
    wgetLink=http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-5.5.0
    tarName=gcc-5.5.0.tar.gz
    untarName=gcc-5.5.0

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
    tar -zxv -f $tarName
    cd $untarName

    #download extra packages fixing depends
    ./contrib/download_prerequisites
    #for ubuntu has privilege, use apt-get install libmpc-dev fix error.
	if [[ $? != 0 ]]; then
		echo [error]: fix depends returns error, quiting now ...
        echo Ubuntu use apt-get install libmpc-dev may fix error ...
		exit
	fi

    ./configure --prefix=$gccInstDir \
                --disable-multilib
    make -j $osCpus
	# check if make returns successfully
	if [[ $? != 0 ]]; then
		echo [error]: make returns error, quiting now ...
		exit
	fi
    $execPrefix make install
    
    cat << _EOF
------------------------------------------------------
INSTALLING GCC DONE ...
`$gccInstDir/bin/gcc --version`
GCC path = $gccInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
	checkOsCpus
    installGcc
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
