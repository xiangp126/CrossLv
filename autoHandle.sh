#!/bin/bash
# Copyright by Peng, 2017. xiangp126@sjtu.edu.cn.
# sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
# > ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*

# basic parameters set.
base_dir=~
bk_files=(
    ".vimrc"
    ".bashrc"
    ".tmux.conf"
    ".vim/colors/corsair.vim"
    ".vim/bundle/snipMate/snippets/c.snippets"
    ".vim/bundle/snipMate/snippets/cpp.snippets"
)
# global parameters.
backup_dir=./widget
dry_dir=./trial
cfm_dir=./confirm
# array to store file names that was trully processed.
bkk_array=()
# backup postfix, need not the first '.'
bk_postfix=old

# traversal of the array. [@] get the full array elements.
# echo ${#bk_files[@]}  => get the length of whole array.
# for file in ${bk_files[@]}
# do 
#     echo file = $file
# done

usage() {
cat << _EOF
[NAME]
    $0 -- auto backup/restore key files of current linux env.

[SYNOPSIS]
    sh $0 [backup | dry | restore | regret | confirm | clean]

[EXAMPLE]
    sh $0 backup
    sh $0 dry
    sh $0 restore

[TROUBLESHOOTING]
    # sh $0 can not be excuted.
    > ll `which sh`
    lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
    # on some distribution, sh was linked to dash, not bash.
    # you have to excute following command mannually. -f if needed.
    > ln -s /bin/bash /bin/sh

[DESCRIPTION]
    backup  -> backup key files under environment to ${backup_dir}/
    dry     -> run restore in dry mode, thought trial/ as ~/
    restore -> restore key files to environment from ${cfm_dir}/
    regret  -> regret previous 'restore'/'dry' action.
    confirm -> confirm to copy files in ${backup_dir}/ to ${cfm_dir}/
    clean   -> clean ${backup_dir}.*/, but reserve main backup dir
_EOF
}

# if no parameters input, print usage() and exit.
# move this check to 'default' branch of case.
# if [ $# -le 0 ]; then
#     usage
#     exit
# fi

backup() {
    # make dir in case it not exist.
    # -p , --parent, no error if existing, make parent directories as needed
    mkdir -p $backup_dir

    # test if backup_dir was trully not empty, backup it first if so.
    # ls -A .
    #    -A, --almost-all
    #       do not list implied . and ..
    if [ "`ls -A $backup_dir`" != "" ]; then
        echo mv ${backup_dir} ${backup_dir}.`date +"%Y-%m-%d-%H:%M:%S"`
        mv ${backup_dir} ${backup_dir}.`date +"%Y-%m-%d-%H:%M:%S"`
    fi

    echo mkdir -p ${backup_dir}/.vim/colors
    mkdir -p ${backup_dir}/.vim/colors
    echo mkdir -p ${backup_dir}/.vim/bundle/snipMate/snippets
    mkdir -p ${backup_dir}/.vim/bundle/snipMate/snippets
    
    # traversal of the array one by one.
    for file in ${bk_files[@]}
    do 
        file=./${file}
        # Exp: ./.vim/colors/corsair.vim
        file_path=`echo ${file%/*}`      # ./.vim/colors 
        file_name=`echo ${file##*/}`     # corsair.vim
        backup_subdir=${backup_dir}/${file_path}
        if [ ! -f ${base_dir}/$file ]; then
            echo [Warning]: There was no ${base_dir}/${file}, omitting it ...
            continue

        fi
        echo "Backup ${base_dir}/${file} to ${backup_subdir}/_${file_name} ..."
        cp ${base_dir}/${file} ${backup_subdir}/_${file_name}
    done

    echo "------------------------------------------------------"
    echo Finding files backuped successfully ...
    echo "------------------------------------------------------"
    find $backup_dir -type f
    echo "------------------------------------------------------"
}

restore() {
    # get restore dir from parameter $1 (the first para passed).
    restore_dir=$1
    # check if exist cfm_dir && restore_dir.
    if [ ! -d ${cfm_dir} ]; then
        echo [Error]: missing confirm $cfm_dir/, please check it first ...
        exit
    fi
    mkdir -p $dry_dir
    # if [ ! -d ${restore_dir} ]; then
    #     echo missing restore directory, please make it first ...
    #     exit
    # fi

    # loop to restore bk_file.
    for file in ${bk_files[@]}
    do
        # ".vim/colors/corsair.vim"
        file=./${file}
        # Exp: ./.vim/colors/corsair.vim
        file_path=`echo ${file%/*}`      # ./.vim/colors 
        file_name=`echo ${file##*/}`     # corsair.vim

        # check if target dir exists, if not make a new one.
        if [ ! -d ${restore_dir}/${file_path} ]; then
            echo "[Warning]: No ${file_path}/ under ${restore_dir}/, so make a new one ..."
            echo mkdir -p ${restore_dir}/${file_path}
            mkdir -p ${restore_dir}/${file_path}
        fi

        cd ${restore_dir}/${file_path}
        echo "Entering Directory `pwd`"
        # check if target file exists, if not make a new one.
        if [ ! -f ${file_name} ]; then
            echo "[Warning]: No $file_name under ${restore_dir}/${file_path}/, so make a new one ..."
        else
            echo mv $file_name ${file_name}.${bk_postfix}
            mv $file_name ${file_name}.${bk_postfix}
        fi

        echo cp ${mainWd}/${cfm_dir}/_${file_name} ${file_name}
        cp ${mainWd}/${cfm_dir}/_${file_name} ${file_name}

        cd $mainWd
        # go back to the main working directory for next cd.
        echo "Going Back to Main Working Directory `pwd`"
        echo
    done

    echo "------------------------------------------------------"
    echo Finding files copied successfully ...
    echo "------------------------------------------------------"
    # loop again to print echo messages.
    for file in ${bk_files[@]}
    do
        # ".vim/colors/corsair.vim"
        file=./${file}
        # Exp: ./.vim/colors/corsair.vim
        file_path=`echo ${file%/*}`      # ./.vim/colors 
        file_name=`echo ${file##*/}`     # corsair.vim

        find ${restore_dir}/${file} -name $file_name
    done
    echo "------------------------------------------------------"

    # echo "------------------------------------------------------"
    # echo find ${restore_dir} -type f
    # echo "------------------------------------------------------"
    # find ${restore_dir} -type f
    # echo "------------------------------------------------------"
    # echo Congratulations! Key Files Has Been Restored ...
}

regret() {
    # get regret dir from parameter $1 (the first para passed).
    regret_dir=$1
    # check if exist cfm_dir && regret_dir.
    if [ ! -d ${regret_dir} ]; then
        echo [Error]: missing regret $regret_dir/, please check it first ...
        exit
    fi
    # mkdir -p $dry_dir

    # i for bkk_array
    index=0
    # loop to regret bk_file.
    for file in ${bk_files[@]}
    do
        # ".vim/colors/corsair.vim"
        file=./${file}
        # Exp: ./.vim/colors/corsair.vim
        file_path=`echo ${file%/*}`      # ./.vim/colors 
        file_name=`echo ${file##*/}`     # corsair.vim
        # backuped file name.
        bk_filename=${file_name}.$bk_postfix

        # check if target dir exists, if not make a new one.
        if [ ! -d ${regret_dir}/${file_path} ]; then
            echo "[Warning]: No ${file_path}/ under ${regret_dir}/, omitting this one ..."
            continue
        fi

        cd ${regret_dir}/${file_path}
        echo "Entering Directory `pwd`"
        # check if target file exists, if not make a new one.
        if [ ! -f ${bk_filename} ]; then
            echo "[Warning]: No $bk_filename under ${regret_dir}/${file_path}/, omitting this one ..."
            # go back to the main working directory for next cd.
            cd $mainWd
            echo -e "Going Back to Main Working Directory `pwd`\n"
            continue
        fi

        echo mv $bk_filename ${file_name}
        mv $bk_filename ${file_name}

        # go back to the main working directory for next cd.
        cd $mainWd
        echo -e "Going Back to Main Working Directory `pwd`\n"
        bkk_array[i++]="`find ${regret_dir}/$file -name $file_name`"

    done


    # get the length of array
    if [ "${#bkk_array[@]}" = '0' ]; then
        echo "------------------------------------------------------"
        echo Sorry, Nothing can be regretted ...
        echo "------------------------------------------------------"
        exit
    fi

    echo "------------------------------------------------------"
    echo Finding files regretted successfully ...
    echo "------------------------------------------------------"
    # loop again to print echo messages.
    for file in ${bkk_array[@]}
    do
        echo $file
    done
    echo "------------------------------------------------------"
}

confirm() {
    if [ ! -d $backup_dir ]; then
        echo "missing backup directory, run '$0 backup' first."
        exit
    fi

    # confirm directory.
    mkdir -p ${cfm_dir}
    # find widget/ -regextype posix-extended -regex '.*' -type f -exec ls -l {} +
    # echo -ne "find ${backup_dir} -regextype posix-basic -regex '^.*' "
    # echo -e "-type f | xargs -i cp {} ${cfm_dir}"
    echo "start to copying files from ${backup_dir}/ to ${cfm_dir}/ ..."
    find ${backup_dir} -regextype posix-basic -regex '^.*' -type f | xargs -i cp {} ${cfm_dir}
    # echo "Congratulations! These Files Are Copied ..."

    echo "------------------------------------------------------"
    echo find ${cfm_dir} -type f
    echo "------------------------------------------------------"
    find ${cfm_dir} -type f
    echo "------------------------------------------------------"
}

# make alias cp = cp -f
alias cp='cp -f'
# main working directory.
mainWd=`pwd`

case $1 in
    'backup')
        backup
    # ;; act as break.
    ;;

    'dry')
        restore $dry_dir
    ;;

    'restore')
        restore ~
    ;;

    'regret')
        regret ~
    ;;

    'confirm')
        confirm
    ;;

    'clean')
        echo rm -rf ${backup_dir}.*
        rm -rf ${backup_dir}.*
    ;;

    # 'default' branch of case
    *)
        usage
        exit
    ;;

esac

