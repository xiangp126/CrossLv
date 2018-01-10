#!/bin/bash
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory, usually ~/myGit
mainWd=$startDir

# GCC install
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
  ____  ____ ____
 / ___|/ ___/ ___|
| |  _| |  | |
| |_| | |__| |___
 \____|\____\____|

_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- setup newly Gcc 5.0

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
STEP : INSTALLING VIM ...
------------------------------------------------------
_EOF
    vimInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'vim'
    vimClonePath=https://github.com/vim/vim
    clonedName=vim
    checkoutVersion=v8.0.1428

    # rename download package
    cd $startDir
    # check if already has this tar ball.
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName/ already exists, Omitting now ...
    else
        git clone ${vimClonePath} $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now ...
            exit
        fi
    fi

    cd $clonedName
    # if need checkout
    git checkout $checkoutVersion
	# clean before ./configure
	make distclean
	# python2Config=`python2-config --configdir`
	# python3Config='/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu/'
	./configure --prefix=$vimInstDir \
			--with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --enable-python3interp=yes \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
    		--enable-gui=gtk2 \
			--enable-cscope
    # ./configure --prefix=$vimInstDir --enable-pythoninterp=yes --enable-python3interp=yes
    make -j $osCpus
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now ...
        exit
    fi
    $execPrefix make install
    cd $startDir

    cat << _EOF
------------------------------------------------------
INSTALLING VIM DONE ...
`$vimInstDir/bin/vim --version`
vim path = $vimInstDir/bin/
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
