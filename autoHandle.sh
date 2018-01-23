#!/bin/bash
# COPYRIGHT BY PENG, 2017. XIANGP126@SJTU.EDU.CN.
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0); pwd)
# primary dir to handle
baseDir=$HOME
# files array needed to track
bkFiles=(
    ".vimrc"
    ".bashrc"
    ".tmux.conf"
    ".ycm_extra_conf.py"
    # ".vim/colors/mydefault.vim"
)
# global parameters.
backupDir=./backup
dryDir=./dry-restore
trackDir=./track
# bash completion
compDir=./completion
# array to store file names that was trully processed.
bkkArray=()
# backup postfix, need not the first '.'
bkPostfix=old
execName=${0##*/}

usage() {
    cat << _EOF
[NAME]
    $execName -- auto backup/restore key files of current linux env.

[SYNOPSIS]
    sh $execName [backup | restore | track | regret | dry | clean]

[EXAMPLE]
    sh $execName backup
    sh $execName dry
    sh $execName restore
    sh $execName track

[TROUBLESHOOTING]
    if 'sh $execName' can not be excuted.
    $ ll `which sh`
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    $ ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ${backupDir}/
    restore -> restore key files to environment from ${trackDir}/
    track   -> copy need tracked files to ${trackDir}/
    regret  -> regret previous 'restore' action as medicine
    dry     -> run restore in dry mode, thought $dryDir/ as $HOME/
    clean   -> clean ${backupDir}.*/, but reserve main backup dir

_EOF
}

backup() {
    # -p , --parent, no error if existing, make parent directories as needed
    cd $mainWd
    mkdir -p $backupDir
    cat << _EOF
------------------------------------------------------
START TO BACKUP TRACKED FILES ...
------------------------------------------------------
_EOF
    # test if backupDir was trully not empty, backup it first if so.
    # ls -A .
    #    -A, --almost-all
    #       do not list implied . and ..
    # if [ "`ls -A $backupDir`" != "" ]; then
    #     echo mv ${backupDir} ${backupDir}.`date +"%Y-%m-%d-%H:%M:%S"`
    #     mv ${backupDir} ${backupDir}.`date +"%Y-%m-%d-%H:%M:%S"`
    # fi
    cd $mainWd
    for file in ${bkFiles[@]}; do
        realFile=$baseDir/$file
        if [[ ! -f $realFile ]]; then
            echo [Warning]: Not found $file under $baseDir, omitting it ...
            continue
        fi
        # .vim/.vimrc => vimrc
        # delete slash if exist, EXp: .vim/colors/.bashrc
        backedName=$(echo ${file##*/})  # .bashrc
        backedName=$(echo ${file#*.})   # bashrc
        echo cp $realFile $backupDir/$backedName ...
        cp $realFile $backupDir/$backedName
    done

    cat << _EOF
------------------------------------------------------
FINDING FILES BACKUPED SUCCESSFULLY ...
------------------------------------------------------
$(find $backupDir -type f)
------------------------------------------------------
_EOF
}

restore() {
    # restore directory as $1
    cd $mainWd
    restoreDir=$1
    # check if exist trackDir && restoreDir.
    if [ ! -d $trackDir ]; then
        echo [Error]: missing track $trackDir/, please check it first ...
        exit
    fi
    if [[ "$restoreDir" != "$baseDir" ]]; then
        mkdir -p $restoreDir
    else
        if [ ! -d $baseDir ]; then
            echo [FatalError]: missing baseDir $baseDir/, please check it first ...
            exit 1
        fi
    fi
    cat << _EOF
------------------------------------------------------
START TO RESTORE TRACKED FILES ...
------------------------------------------------------
_EOF
    copiedPathArray=()
    index=0
    cd $mainWd
    for file in ${bkFiles[@]}; do
        # .vim/.vimrc => vimrc
        # real name under track/
        backedName=$(echo ${file##*/})  # .bashrc
        backedName=$(echo ${file#*.})   # bashrc
        if [[ ! -f $trackDir/$backedName ]]; then
            echo "[Warning]: Not found $backedName under $trackDir, omitting $backedName ..."
            continue
        fi
        # backup original file before restored
        realFile=$restoreDir/$file
        if [[ -f $realFile ]]; then
            echo [Warning]: found $file under $restoreDir, back it up ...
            realBackedFile=$restoreDir/$file.$bkPostfix
            echo mv $realFile $realBackedFile
            mv $realFile $realBackedFile
        fi
        echo cp $trackDir/$backedName $realFile
        cp $trackDir/$backedName $realFile

        # fill in copiedPathArray
        copiedPathArray[((index++))]=$realFile
    done
    cat << _EOF
------------------------------------------------------
FINDING FILES RESTORED SUCCESSFULLY ...
------------------------------------------------------
_EOF
    for file in ${copiedPathArray[@]}; do
        echo $file
    done

    cat << _EOF
------------------------------------------------------
START TO COPYING BASH COMPLETION FILES ...
------------------------------------------------------
_EOF
    myCompleteDir=$HOME/.completion.d
    mkdir -p $myCompleteDir
    for file in `find $compDir -regex ".*.bash" -type f`
    do
        echo cp -f $file $myCompleteDir/
        cp $file $myCompleteDir/
    done

    cat << _EOF
------------------------------------------------------
FINDING BASH-COMPLETION SUCCESSFULLY COPIED ...
------------------------------------------------------
_EOF
    find $myCompleteDir -type f
    echo ------------------------------------------------------
}

regret() {
    # regret dir as $1
    regretDir=$1
    # check if exist trackDir && regretDir.
    if [ ! -d ${regretDir} ]; then
        echo [Error]: missing regret $regretDir/, please check it first ...
        exit
    fi

    cd $mainWd
    for file in ${bkFiles[@]}; do
        realBkFile=$regretDir/$file.$bkPostfix
        if [[ ! -f $realBkFile ]]; then
            echo [Warning]: not found $file.$bkPostfix under $regretDir, omitting it ...
            continue
        fi
        echo mv $realBkFile $regretDir/$file
        mv $realBkFile $regretDir/$file
    done
}

track() {
    if [ ! -d $backupDir ]; then
        echo "[FatalError]: missing backup directory, run '$execName backup' first."
        exit
    fi
    # track directory.
    if [[ ! -d $trackDir ]]; then
        mkdir -p ${trackDir}
    fi
    cat << _EOF
---------------------------------------------------------
COPY TRACKED FILES FROM $backupDir TO $trackDir ...
---------------------------------------------------------
_EOF
    for file in `find $backupDir -type f`; do
        fileName=`echo ${file##*/}`
        echo cp $file $trackDir/$fileName
        cp $file $trackDir/$fileName
    done
    cat << _EOF
------------------------------------------------------
FINDING TRACK FILES TRACKED SUCCESSFULLY ...
------------------------------------------------------
_EOF
    find $trackDir -type f

    cd $mainWd
    privateColorDir=$HOME/.vim/colors
    trackedColorDir=./vim-colors
    if [[ ! -d $trackedColorDir ]]; then
        echo "[Error]: Not found tracked color $trackedColorDir/, please check it ..."
        exit 1
    fi
    if [[ ! -d $privateColorDir ]]; then
        return
    fi
    cat << _EOF
---------------------------------------------------------
START TO TRACK PRIVATE COLORS ...
---------------------------------------------------------
_EOF
    for file in `find $privateColorDir -regex ".*.vim$"`; do
        echo cp $file $trackedColorDir/
        cp $file $trackedColorDir/
    done
    cat << _EOF
------------------------------------------------------
FINDING TRACK FILES TRACKED SUCCESSFULLY ...
------------------------------------------------------
_EOF
}

case $1 in
    'backup')
        backup
    ;;

    'dry')
        restore $dryDir
    ;;

    'restore')
        restore $HOME
    ;;

    'regret')
        regret $HOME
    ;;

    'track')
        track
    ;;

    'clean')
        echo rm -rf ${backupDir}.*
        rm -rf ${backupDir}.*
    ;;

    *)
        usage
        exit
    ;;
esac
