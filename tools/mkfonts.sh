#!/bin/bash
set -x
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0)/../; pwd)
#mainWd=$startDir
# dir to handle font from
fontsDir=fonts
sysFontsDir=/usr/share/fonts/truetype
newTtfDir=myfonts
fullNewTftDir=$sysFontsDir/$newTtfDir
# execute prefix
execPrefix=sudo

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- make new font from $mainWd/$fontsDir/ 
                        to $sysFontsDir/

[USAGE]
    sh $exeName [install | uninstall | help]

_EOF
}

makeFonts() {
    if [[ ! -d $sysFontsDir ]]; then
        echo "[Error]: Not found $sysFontsDir/, quitting now ..."
        exit
    fi
    $execPrefix mkdir -p $fullNewTftDir

    cd $mainWd
    cd $fontsDir
    for fontName in `find . -regex ".*.[ttf|ttc]"`
    do
        hasThisTtf=`find $fullNewTftDir -name ${fontName#./}`
        if [[ $hasThisTtf != "" ]]; then
            echo "[Warning]: font $fontName already in $fullNewTftDir, omitting this one ..."
            continue
            echo -----------------------------------------------
        fi
        echo "Found font $fontName ready to install ..."
        $execPrefix cp $fontName $fullNewTftDir
    done
    echo -----------------------------------------------

    cd $sysFontsDir
    $execPrefix mkfontscale
    # create an index of X font files in a directory
    $execPrefix mkfontdir
    $execPrefix fc-cache -fv
}

rmFonts() {
    if [[ ! -d $fullNewTftDir ]]; then
        echo [Error]: Not found new added $fullNewTftDir/, quitting now ...
        exit
    fi

    cd $sysFontsDir
    echo "Removing directory $fullNewTftDir..."
    echo -----------------------------------------------
    $execPrefix rm -rf $newTtfDir

    $execPrefix fc-cache -fv
}

case $1 in 
    'install')
        makeFonts
        exit 0
    ;;
    
    'uninstall')
        rmFonts
        exit 0
    ;;

    *)
        usage
        exit 0
    ;;
esac
