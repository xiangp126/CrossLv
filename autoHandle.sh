#!/bin/bash
# COPYRIGHT BY PENG, 2017. XIANGP126@SJTU.EDU.CN.
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0); pwd)
# basic parameters set.
baseDir=$HOME
# YouCompleteMe not compatible with snipMate
bkFiles=(
    ".vimrc"
    ".bashrc"
    ".tmux.conf"
    ".ycm_extra_conf.py"
    ".vim/colors/darkcoding.vim"
)
# global parameters.
backupDir=./backup
dryDir=./dry_restore
cfmDir=./confirm
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
    sh $execName [backup | dry | restore | regret | confirm | clean]

[EXAMPLE]
    sh $execName backup
    sh $execName dry
    sh $execName restore

[TROUBLESHOOTING]
    if 'sh $execName' can not be excuted.
    $ ll `which sh`
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    $ ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ${backupDir}/
    dry     -> run restore in dry mode, thought $dryDir/ as $HOME/
    restore -> restore key files to environment from ${cfmDir}/
    regret  -> regret previous 'restore' action as medicine
    confirm -> confirm to copy files in ${backupDir}/ to ${cfmDir}/
    clean   -> clean ${backupDir}.*/, but reserve main backup dir
_EOF
}

backup() {
    # -p , --parent, no error if existing, make parent directories as needed
    cd $mainWd
    mkdir -p $backupDir

    # test if backupDir was trully not empty, backup it first if so.
    # ls -A .
    #    -A, --almost-all
    #       do not list implied . and ..
    # if [ "`ls -A $backupDir`" != "" ]; then
    #     echo mv ${backupDir} ${backupDir}.`date +"%Y-%m-%d-%H:%M:%S"`
    #     mv ${backupDir} ${backupDir}.`date +"%Y-%m-%d-%H:%M:%S"`
    # fi
    echo mkdir -p ${backupDir}/.vim/colors
    mkdir -p ${backupDir}/.vim/colors
    # traversal of the array one by one.
    for file in ${bkFiles[@]}
    do 
        file=./${file}                 # Exp: ./.vim/colors/corsair.vim
        filePath=`echo ${file%/*}`     # ./.vim/colors 
        fileName=`echo ${file##*/}`    # corsair.vim
        bkSubDir=${backupDir}/${filePath}
        if [ ! -f ${baseDir}/$file ]; then
            echo [Warning]: There was no ${baseDir}/${file}, omitting it ...
            continue
        fi
        echo "Backup ${baseDir}/${file} to ${bkSubDir}/_${fileName} ..."
        cp ${baseDir}/${file} ${bkSubDir}/_${fileName}
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
    # check if exist cfmDir && restoreDir.
    if [ ! -d ${cfmDir} ]; then
        echo [Error]: missing confirm $cfmDir/, please check it first ...
        exit
    fi
    # mkdir -p $restoreDir
    if [[ "$restoreDir" != "$baseDir" ]]; then
        if [ ! -d ${restoreDir} ]; then
            mkdir -p $restoreDir
        fi
    fi
    cat << _EOF
------------------------------------------------------
START TO RUN RESTORE ROUTINE ...
------------------------------------------------------
_EOF
    # already copied file path was stored in this array.
    copiedPathArray=()
    index=0
    # loop to restore bk_file.
    for file in ${bkFiles[@]}
    do
        file=./${file}                  # ./.vim/colors/corsair.vim
        filePath=`echo ${file%/*}`      # ./.vim/colors 
        fileName=`echo ${file##*/}`     # corsair.vim
        # fill in copiedPathArray
        copiedPathArray[((index++))]=$file

        # check if target dir exists, if not make a new one.
        if [ ! -d ${restoreDir}/${filePath} ]; then
            echo "[Warning]: No ${filePath}/ under ${restoreDir}/, so make a new one ..."
            echo mkdir -p ${restoreDir}/${filePath}
            mkdir -p ${restoreDir}/${filePath}
        fi

        cd ${restoreDir}/${filePath}
        echo "Entering Directory `pwd`"
        # check if target file exists, if not make a new one.
        if [ ! -f ${fileName} ]; then
            echo "[Warning]: No $fileName under ${restoreDir}/${filePath}/, so make a new one ..."
        else
            echo mv $fileName ${fileName}.${bkPostfix}
            mv $fileName ${fileName}.${bkPostfix}
        fi

        echo cp ${mainWd}/${cfmDir}/_${fileName} ${fileName}
        cp ${mainWd}/${cfmDir}/_${fileName} ${fileName}

        cd $mainWd
        # go back to the main working directory for next cd.
        # echo -e "Going Back to Main Working Directory `pwd`\n"
        echo 
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
        cp -f $file $myCompleteDir/
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
    # check if exist cfmDir && regretDir.
    if [ ! -d ${regretDir} ]; then
        echo [Error]: missing regret $regretDir/, please check it first ...
        exit
    fi
    # mkdir -p $dryDir

    # i for bkkArray
    index=0
    # loop to regret bk_file.
    for file in ${bkFiles[@]}
    do
        file=./${file}                # ./.vim/colors/corsair.vim
        filePath=`echo ${file%/*}`    # ./.vim/colors 
        fileName=`echo ${file##*/}`   # corsair.vim
        # backuped file name.
        bkFileName=${fileName}.$bkPostfix

        # check if target dir exists, if not make a new one.
        if [ ! -d ${regretDir}/${filePath} ]; then
            echo "[Warning]: No ${filePath}/ under ${regretDir}/, omitting this one ..."
            continue
        fi

        cd ${regretDir}/${filePath}
        echo "Entering Directory `pwd`"
        # check if target file exists, if not make a new one.
        if [ ! -f ${bkFileName} ]; then
            echo "[Warning]: No $bkFileName under ${regretDir}/${filePath}/, omitting this one ..."
            # go back to the main working directory for next cd.
            cd $mainWd
            # echo -e "Going Back to Main Working Directory `pwd`\n"
            echo
            continue
        fi

        echo mv $bkFileName ${fileName}
        mv $bkFileName ${fileName}

        # go back to the main working directory for next cd.
        cd $mainWd
        # echo -e "Going Back to Main Working Directory `pwd`\n"
        echo
        bkkArray[i++]="`find ${regretDir}/$file -name $fileName`"
    done

    # get the length of array
    if [ "${#bkkArray[@]}" = '0' ]; then
        echo "------------------------------------------------------"
        echo SORRY, NOTHING CAN BE REGRETTED ...
        echo "------------------------------------------------------"
        exit
    fi

    echo "------------------------------------------------------"
    echo FINDING FILES REGRETTED SUCCESSFULLY ...
    echo "------------------------------------------------------"
    # loop again to print echo messages.
    for file in ${bkkArray[@]}
    do
        echo $file
    done
    echo "------------------------------------------------------"
}

confirm() {
    if [ ! -d $backupDir ]; then
        echo "missing backup directory, run '$execName backup' first."
        exit
    fi

    # confirm directory.
    if [[ ! -d $cfmDir ]]; then
        mkdir -p ${cfmDir}
    fi
    # find backup/ -regextype posix-extended -regex '.*' -type f -exec ls -l {} +
    # echo -ne "find ${backupDir} -regextype posix-basic -regex '^.*' "
    # echo -e "-type f | xargs -i cp {} ${cfmDir}"
    echo "START TO COPYING FILES FROM ${backupDir}/ TO ${cfmDir}/ ..."
    # change below syntax becase MAC did not support
    # find ${backupDir} -regextype posix-basic -regex '^.*' -type f | xargs -i cp {} ${cfmDir}
    for file in `find $backupDir -type f`
    do
        cpiedName=`basename $file`
        echo cp -f $file ${cfmDir}/$cpiedName ...
        cp -f $file ${cfmDir}/$cpiedName
    done

    # echo "Congratulations! These Files Are Copied ..."
    echo "------------------------------------------------------"
    echo find ${cfmDir} -type f
    echo "------------------------------------------------------"
    find ${cfmDir} -type f
    echo "------------------------------------------------------"
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

    'confirm')
        confirm
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
