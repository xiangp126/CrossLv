#!/bin/bash
set -x
myGccDir=/usr/local/bin
sysGccDir=/usr/bin/

startDir=`pwd`
mainWd=$startDir
tackleFile=(
    "gcc"
    "g++"
    "c++"
)
#backup suffix
bksuffix=sys

usage() {
	exeName=${0##*/}
	cat << _EOF
[NAME]
    $exeName -- link/unlink of self-compiled gcc to system gcc location

[SYNOPSIS]
    $exeName [link | unlink | help]

[DESCRIPTION]
    link gcc/c++ from $myGccDir to $sysGccDir
    || need root privilege

_EOF
}

case $1 in
    'link' )
        cd $sysGccDir
        #gcc => gcc-sys
        for file in "${tackleFile[@]}" ; do
            lnSrcFileName=$myGccDir/$file
            if [[ -f "$file-$bksuffix" ]]; then
                echo "[Error]: already linked file exist, quiting now ..."
                echo you should run unlink rather than link.
                exit
            fi
            if [[ ! -f "$lnSrcFileName" ]]; then
                echo "[Warning]: has no $lnSrcFileName under $myGccDir, omitting it ..."
                continue
            fi
            sudo mv $file $file-$bksuffix
            sudo ln -s $lnSrcFileName $file
        done
    ;;

    'unlink' )
        cd $sysGccDir
        #gcc-sys => gcc
        for file in "${tackleFile[@]}" ; do
            bkFileName=$file-$bksuffix
            if [[ ! -f "$bkFileName" ]]; then
                echo "[Warning]: has no $bkFileName under $sysGccDir, omitting it ..."
                continue
            fi
            sudo mv $file-$bksuffix $file
        done
    ;;

    *)
        usage
    ;;
esac
