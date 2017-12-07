# Copyright by Peng. xiangp126@sjtu.edu.cn.
# Dec 07, 2017 last edit.
# sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
# > ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
#!/bin/bash
base_dir=~
backup_dir="widget"
bk_files=(
    ".vimrc"
    ".bashrc"
    ".vim/colors/corsair.vim"
    ".vim/bundle/snipMate/snippets/c.snippets"
    ".vim/bundle/snipMate/snippets/cpp.snippets"
)

# traversal of the array. [@] get the full array elements.
# echo ${#bk_files[@]}  => get the length of whole array.
# for file in ${bk_files[@]}
# do 
#     echo file = $file
# done

usage() {
    echo "usage: $0 backup | restore | confirm | clean"
    echo "backup  -> backup key files under environment to dir: ${backup_dir}"
    echo "restore -> restore key files to environment from this git repo."
    echo "confirm -> confirm to replace key files of this git repo with them under dir: ${backup_dir}."
    echo "clean   -> clean dir: ${backup_dir} and subdirs."
}

# if no parameters input, print usage() and exit.
if [ $# -le 0 ]; then
    usage
    exit
fi

# make alias cp = cp -f
alias cp='cp -f'
# main working directory.
mainWd=`pwd`

case $1 in
    'backup')
        if [ -d "${backup_dir}/.vim/colors" ]; then
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
            echo "Backup ${base_dir}/${file} to ${backup_subdir}/_${file_name} ..."
            cp ${base_dir}/${file} ${backup_subdir}/_${file_name}
        done
    ;;

    'restore')
        restore_dir=./hehe
        cfm_dir=./confirm
        # mv .vimrc  => .vimrc.git.bak
        bk_postfix=git.bak
        # check if exist cfm_dir && restore_dir.
        if [ ! -d ${cfm_dir} ]; then
            echo Have No Confirm Directory, Abort Now ...
            exit
        fi
        if [ ! -d ${restore_dir} ]; then
            echo Have No Restore Directory, Abort Now ...
            exit
        fi

        # loop to restore bk_file.
        for file in ${bk_files[@]}
        do
            # ".vim/colors/corsair.vim"
            file=./${file}
            # Exp: ./.vim/colors/corsair.vim
            file_path=`echo ${file%/*}`      # ./.vim/colors 
            file_name=`echo ${file##*/}`     # corsair.vim

            # check if target dir exists, if not just abort.
            if [ ! -d ${restore_dir}/${file_path} ]; then
                echo -n "There is No Dir ${file_path} under ${restore_dir}, "
                echo    "Abort Now ..."
                exit
            fi

            cd ${restore_dir}/${file_path}
            echo "Entering Directory `pwd`"
            # check if target file exists, if not just omit it.
            if [ ! -f ${file_name} ]; then
                echo There is No $file_name under ${restore_dir}/${file_path}, omit $file_name ... 
                continue
            fi

            echo mv $file_name ${file_name}.${bk_postfix}
            mv $file_name ${file_name}.${bk_postfix}
            echo cp ${mainWd}/${cfm_dir}/_${file_name} ${file_name}
            cp ${mainWd}/${cfm_dir}/_${file_name} ${file_name}

            cd $mainWd
            # go back to the main working directory for next cd.
            echo "Going Back to Main Working Directory `pwd`"
            echo
        done
        echo Congratulations! Key Files Has Been Restored ...
    ;;

    'confirm')
        # confirm directory.
        mkdir -p ${cfm_dir}
        # find widget/ -regextype posix-extended -regex '.*' -type f -exec ls -l {} +
        # echo -ne "find ${backup_dir} -regextype posix-basic -regex '^.*' "
        # echo -e "-type f | xargs -i cp {} ${cfm_dir}"
        find ${backup_dir} -regextype posix-basic -regex '^.*' -type f | xargs -i cp {} ${cfm_dir}
        ls -l ${cfm_dir}
        echo "Congratulations! These Files Copied ..."
    ;;

    'clean')
        echo rm -rf ${backup_dir}
        rm -rf ${backup_dir}
        echo rm -rf ${backup_dir}.*
        rm -rf ${backup_dir}.*
    ;;
esac

