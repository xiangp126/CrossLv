#!/bin/bash
# COPYRIGHT BY PENG, 2017. XIANGP126@SJTU.EDU.CN.
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0); pwd)
# track files baseline directory
tkBaseDir=$HOME
# files array needed to track
# ".vim/colors/mydefault.vim"
trackFiles=(
    ".vimrc"
    ".tmux.conf"
    ".gitconfig"
    ".gitignore"
    ".bashrc"
    # ".ycm_extra_conf.py"
)
# private colors needed to track
privateColorDir=$HOME/.vim/colors
# backup directory
backupDir=./backup
# backup private colors
bkColorDir=$backupDir/colors
# track dir under try mode, only for test
dryDir=./dry-restore
# dir to store tracked files
trackDir=./track-files
# dir to store tracked color files
trackedColorDir=./vim-colors
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
    sh $execName [restore | backup | track | auto | regret | clean]

[EXAMPLE]
    sh $execName backup
    sh $execName track
    sh $execName restore
    sh $execName auto

[TROUBLESHOOTING]
    if 'sh $execName' can not be excuted.
    $ ll `which sh`
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    $ ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup tracked files under environment to ${backupDir}/
    track   -> deploy tracked files from 'backup-ed' to ${trackDir}/
    restore -> restore tracked files to environment from ${trackDir}/
    regret  -> regret previous 'restore' action as medicine
    auto    -> run 'backup' & 'track' as pack
    clean   -> clean ${backupDir}.*/, but reserve main backup dir

_EOF
}

backup() {
    if [[ ! -d $backupDir ]]; then
        mkdir -p $backupDir
    fi
    cat << _EOF
------------------------------------------------------
READY TO BACKUP TRACKED FILES
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
    for file in ${trackFiles[@]}; do
        realFile=$tkBaseDir/$file
        if [[ ! -f $realFile ]]; then
            echo [Warning]: Not found $file under $tkBaseDir, omitting it
            continue
        fi
        # delete slash if exist, EXp: .vim/colors/.bashrc
        bkName=${file##*/}        # .bashrc
        backedName=${bkName#*.}   # bashrc
        echo cp $realFile $backupDir/$backedName
        cp $realFile $backupDir/$backedName
    done

    # backup private colors
    cd $mainWd
    if [[ ! -d $privateColorDir ]]; then
        return
    fi
    if [[ ! -d $bkColorDir ]]; then
        mkdir -p $bkColorDir
    fi
    cat << _EOF
---------------------------------------------------------
READY TO BACKUP PRIVATE COLORS
---------------------------------------------------------
_EOF
    for file in `find $privateColorDir -regex ".*.vim$"`; do
        echo cp $file $bkColorDir/
        cp $file $bkColorDir/
    done
    cat << _EOF
---------------------------------------------------------
FINDING FILES BACKUPED SUCCESSFULLY
---------------------------------------------------------
$(find $backupDir -maxdepth 1 -type f 2> /dev/null)
-------> ✄
$(find $backupDir -mindepth 2 -type f 2> /dev/null)
---------------------------------------------------------
_EOF
}

restore() {
    # restore directory as $1
    cd $mainWd
    restoreDir=$1
    # check if exist trackDir && restoreDir.
    if [ ! -d $trackDir ]; then
        echo [Error]: missing track $trackDir/, please check it first
        exit 255
    fi
    if [[ "$restoreDir" != "$tkBaseDir" ]]; then
        mkdir -p $restoreDir
    else
        if [ ! -d $tkBaseDir ]; then
            echo [FatalError]: missing track files base dir $tkBaseDir/
            exit 255
        fi
    fi
    cat << _EOF
------------------------------------------------------
UPDATING TRACK FILES TO SYSTEM ENVIRONMENT
------------------------------------------------------
_EOF
    copiedPathArray=()
    index=0
    cd $mainWd
    for file in ${trackFiles[@]}; do
        # .vim/.vimrc => vimrc
        # real name under track/
        bkName=${file##*/}        # .bashrc
        trackName=${bkName#*.}    # bashrc

        trackFile=$trackDir/$trackName
        if [[ ! -f $trackFile ]]; then
            echo "[Warning]: Not found $trackName under $trackDir/, omitting it"
            continue
        fi
        realFile=$restoreDir/$file
        if [[ -f $realFile ]]; then
            # # move original file to *.old before restored
            # realBackedFile=$restoreDir/$file.$bkPostfix
            # echo mv $realFile $realBackedFile
            # mv $realFile $realBackedFile

            # only restore when has difference
            diffContent=`diff $trackFile $realFile`
            if [[ $diffContent == "" ]]; then
                continue
            fi
        fi
        echo cp $trackDir/$trackName $realFile
        cp $trackDir/$trackName $realFile
        # fill in copiedPathArray
        copiedPathArray[((index++))]=$realFile
    done
    if [[ $index == '0' ]]; then
        echo Clean ...
    fi

    cat << _EOF
------------------------------------------------------
UPDATING TRACK COLORS TO SYSTEM ENVIRONMENT
------------------------------------------------------
_EOF
    cd $mainWd
    # trackedColorDir=./vim-colors
    # compatible with dry mode
    privateColorDir=$restoreDir/.vim/colors
    if [[ ! -d $privateColorDir ]]; then
        mkdir -p $privateColorDir
    fi

    colorCnt=0
    for colorName in `find $trackedColorDir -regex '.*.vim$' -type f`
    do
        onlyFileName=${colorName##*/}
        toUpdateFile=$privateColorDir/$onlyFileName
        if [[ -f $toUpdateFile ]]; then
            diffContent=`diff $colorName $toUpdateFile`
            if [[ $diffContent == "" ]]; then
                continue
            fi
        fi
        echo cp $colorName $privateColorDir
        cp $colorName $toUpdateFile
        # fill in copiedPathArray
        copiedPathArray[((index++))]=$toUpdateFile
        # color count plus
        ((colorCnt++))
    done

    if [[ $colorCnt == '0' ]]; then
        echo Clean ...
    elif [[ $index == '0' ]]; then
        return
    fi

    if [[ $index == '0' ]]; then
        cat << _EOF
------------------------------------------------------
YOUR ENVIRONMENT ALREADY THE LATEST VERSION
------------------------------------------------------
_EOF
        return
    fi
    cat << _EOF
------------------------------------------------------
FINDING FILES NEWLY RESTORED SUCCESSFULLY
-------> ✄
_EOF
    for file in ${copiedPathArray[@]}; do
        echo $file
    done
    echo ------------------------------------------------------
}

track() {
    if [ ! -d $backupDir ]; then
        echo "[FatalError]: missing backup directory, run '$execName backup' first."
        exit 255
    fi
    # track directory.
    if [[ ! -d $trackDir ]]; then
        echo "FatalError: missing $trackDir/, please check first"
        exit 255
    fi
    cat << _EOF
---------------------------------------------------------
UPDATING TRACK FILES FROME BACKUP DIRECTORY
---------------------------------------------------------
_EOF
    cd $mainWd
    copiedPathArray=()
    index=0
    for file in ${trackFiles[@]}; do
        # .vim/.vimrc => vimrc
        # delete slash if exist, EXp: .vim/colors/.bashrc
        bkName=${file##*/}        # .bashrc
        backedName=${bkName#*.}   # bashrc

        realFile=$backupDir/$backedName      # ./backup/bashrc
        toTrackedFile=$trackDir/$backedName  # ./track-files/bashrc
        if [[ ! -f $realFile || ! -f $toTrackedFile ]]; then
            continue
        fi
        # only copy when has difference
        diffContent=`diff $realFile $toTrackedFile`
        if [[ $diffContent == "" ]]; then
            continue
        fi
        echo cp $realFile $trackDir/
        cp $realFile $toTrackedFile
        copiedPathArray[((index++))]=$toTrackedFile
    done

    if [[ $index == '0' ]]; then
        echo Clean ...
    fi

    cat << _EOF
---------------------------------------------------------
UPDATING TRACK COLORS FROM BACKUP DIRECTORY
---------------------------------------------------------
_EOF
    cd $mainWd
    # privateColorDir=$HOME/.vim/colors
    # trackedColorDir=./vim-colors
    if [[ ! -d $bkColorDir ]]; then
        return
    fi

    colorCnt=0
    for colorName in `find $bkColorDir -regex '.*.vim$' -type f`
    do
        onlyFileName=${colorName##*/}
        toTrackedFile=$trackedColorDir/$onlyFileName
        if [[ ! -f $toTrackedFile ]]; then
            continue
        else
            diffContent=`diff $colorName $toTrackedFile`
            if [[ $diffContent == "" ]]; then
                continue
            fi
        fi
        echo cp $colorName $trackedColorDir
        cp $colorName $toTrackedFile
        # fill in copiedPathArray
        copiedPathArray[((index++))]=$toTrackedFile
        # color cnt plus
        ((colorCnt++))
    done

    if [[ $colorCnt == '0' ]]; then
        echo Clean ...
    elif [[ $index == '0' ]]; then
        return
    fi

    if [[ $index == '0' ]]; then
    cat << _EOF
---------------------------------------------------------
NOTHING TO UPDATE, ALREADY THE SAME
---------------------------------------------------------
_EOF
        return
    fi
    cat << _EOF
---------------------------------------------------------
FINDING FILES NEWLY UPDATED SUCCESSFULLY
-------> ✄
_EOF
    for file in ${copiedPathArray[@]}; do
        echo $file
    done
    echo ---------------------------------------------------------
}

regret() {
    regretDir=$HOME
    if [ ! -d $regretDir ]; then
        echo "[FatalError]: missing backup directory, can not run 'regret'"
        exit 255
    fi

    cat << _EOF
---------------------------------------------------------
REGRETTING TRACK FILES FROME BACKUP DIRECTORY
---------------------------------------------------------
_EOF
    cd $mainWd
    copiedPathArray=()
    index=0
    for file in ${trackFiles[@]}; do
        # .vim/.vimrc => vimrc
        # delete slash if exist, EXp: .vim/colors/.bashrc
        bkName=${file##*/}        # .bashrc
        backedName=${bkName#*.}   # bashrc
        realBkFile=$backupDir/$backedName        # ./backup/bashrc
        toRegretedFile=$regretDir/$bkName        # $HOME/.bashrc

        # if missing real backuped file
        if [[ ! -f $realBkFile ]]; then
            continue
        fi

        if [[ -f $toRegretedFile ]]; then
            # only copy when has difference
            diffContent=`diff $realBkFile $toRegretedFile`
            if [[ $diffContent == "" ]]; then
                continue
            fi
        fi
        echo cp $realBkFile $regretDir/
        cp $realBkFile $toRegretedFile
        copiedPathArray[((index++))]=$toRegretedFile
    done

    if [[ $index == '0' ]]; then
        echo Clean ...
    fi

    cat << _EOF
---------------------------------------------------------
REGRETTING TRACK COLORS FROM BACKUP DIRECTORY
---------------------------------------------------------
_EOF
    cd $mainWd
    # privateColorDir=$HOME/.vim/colors
    # trackedColorDir=./vim-colors
    # bkColorDir=$backupDir/colors
    if [[ ! -d $bkColorDir ]]; then
        return
    fi

    colorCnt=0
    for colorName in `find $bkColorDir -regex '.*.vim$' -type f`
    do
        onlyFileName=${colorName##*/}
        toRegretedFile=$privateColorDir/$onlyFileName
        if [[ -f $toRegretedFile ]]; then
            diffContent=`diff $colorName $toRegretedFile`
            if [[ $diffContent == "" ]]; then
                continue
            fi
        fi
        echo cp $colorName $privateColorDir
        cp $colorName $toRegretedFile
        # fill in copiedPathArray
        copiedPathArray[((index++))]=$toRegretedFile
        # color cnt plus
        ((colorCnt++))
    done

    if [[ $colorCnt == '0' ]]; then
        echo Clean ...
    elif [[ $index == '0' ]]; then
        return
    fi

    if [[ $index == '0' ]]; then
    cat << _EOF
---------------------------------------------------------
NOTHING TO REGRET, ALREADY THE SAME
---------------------------------------------------------
_EOF
        return
    fi
    cat << _EOF
---------------------------------------------------------
FINDING FILES REGRETED SUCCESSFULLY
-------> ✄
_EOF
    for file in ${copiedPathArray[@]}; do
        echo $file
    done
    echo ---------------------------------------------------------
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

    'auto')
        backup
        echo
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
