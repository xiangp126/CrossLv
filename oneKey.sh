#!/bin/bash
# Copyright by Peng, 2018. xiangp126@sjtu.edu.cn.
# sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
# > ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
set -x
# global parameters.
baseDir=~
bkPostfix=old
tackleDir=(
    ".vim"
    ".tmux"
)
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
#default install vim to home directory
passedPara="home"
#get this value from install VIM script
vimInstDir=$homeInstDir

logo() {
    cat << "_EOF"
                   _     _
 _ __ ___  _   _  | |   (_)_ __  _   ___  __
| '_ ` _ \| | | | | |   | | '_ \| | | \ \/ /
| | | | | | |_| | | |___| | | | | |_| |>  <
|_| |_| |_|\__, | |_____|_|_| |_|\__,_/_/\_\
           |___/

_EOF
}

vimThroughCmd() {
cat << _EOF
    --- EXECUTE VIM COMMANDS THROUGH COMMAND LINE ---
    [sample 1] vim +PluginInstall +qall
    equals $ vim and then :PluginInstall and then :qall
    [sample 2] vim +"help tags"
    equals $ vim and then :help tags
    --------------- END OF THIS NOTE ----------------
_EOF
}

usage() {
	exeName=${0##*/}
	cat << _EOF
[NAME]
    $exeName -- onekey to setup my working environment | - tmux
    | - vim | - vundle -- youcompleteme -- supertab -- vim-snippets
             -- ultisnips -- nerdtree -- auto-pairs

[SYNOPSIS]
    $exeName [home | root | help]

[DESCRIPTION]
    home -- build VIM to $homeInstDir/
    root -- build VIM to $rootInstDir/

_EOF
set +x
    logo
}    

#install vim and tmux
installBone() {
    if [ ! -d $baseDir ]; then
        echo mkdir -p $baseDir
        mkdir -p $baseDir
    fi

    # run backup first of all.
    cat << _EOF
------------------------------------------------------
STEP : RUN BACKUP FIRST ...
------------------------------------------------------
_EOF
    sh autoHandle.sh backup

    # absolute file path.
    for tdir in "${tackleDir[@]}"
    do
        abPath=${baseDir}/${tdir}
        # remove .old files before mv overwrite.
        rm -rf ${abPath}.$bkPostfix
        echo mv ${abPath} ${abPath}.$bkPostfix 2>/dev/null
        mv ${abPath} ${abPath}.$bkPostfix 2>/dev/null
    done

    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING VIM-PLUGIN MANAGER ...
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/VundleVim/Vundle.vim
    clonedName=${baseDir}/${tackleDir[0]}/bundle/Vundle.vim
    # check if target directory already exists
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName already exists, Omitting clone ...
    else
        git clone $gitClonePath $clonedName 
        # check if git returns successfully
        if [[ $? != 0 ]]; then
            echo "[Error]: git returns error, quiting now ..."
            exit
        fi
    fi

    cat << "_EOF"
------------------------------------------------------
INSTALLING VIM-PLUGIN MANAGER DONE
_EOF

    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING TMUX-PLUGIN MANAGER
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/tmux-plugins/tpm 
    clonedName=${baseDir}/${tackleDir[1]}/plugins/tpm
    git clone $gitClonePath $clonedName 
    # check if target directory already exists
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName already exists, Omitting clone ...
    else
        git clone $gitClonePath $clonedName 
        # check if git returns successfully
        if [[ $? != 0 ]]; then
            echo "[Error]: git returns error, quiting now ..."
            exit
        fi
    fi

    cat << "_EOF"
------------------------------------------------------
INSTALLING TMUX-PLUGIN MANAGER DONE
------------------------------------------------------
_EOF

    cat << _EOF
REPLACING SOME KEY FILES FIRST ...
------------------------------------------------------
_EOF
    cp -f ./confirm/_.vimrc ${baseDir}/.vimrc
    # replace corsair.vim ahead of whole restore
    mkdir -p ${baseDir}/${tackleDir[0]}/colors
    cp -f ./confirm/_corsair.vim ${baseDir}/${tackleDir[0]}/colors/corsair.vim
}

installVimPlugins() {
 	#81 Plugin 'Valloric/YouCompleteMe'
	tackleFile=~/.vimrc
	# comment YouCompleteMe in ~/.vimrc
	#it takes too long time, manually compile in cc-ycm.sh
	sed -i --regexp-extended "s/(^Plugin 'Valloric)/\" \1/" $tackleFile

    # source ~/.vimrc if needed
    vim +"source ~/.vimrc" +PluginInstall +qall
    sh autoHandle.sh restore

    cat << "_EOF"
------------------------------------------------------
INSTALL NEWLY VIM AND COMPILE YCM ...
------------------------------------------------------
_EOF
	vimYcmScript=cc-ycm.sh
    #vimInstDir=`sh $vimYcmScript $passedPara`
    if [[ "$vimInstDir" == "" ]]; then
        echo "[Error]: Not fould self-compiled VIM, quitting now ..."
        exit
    fi

    sh $vimYcmScript $passedPara
    # check if command returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: $vimYcmScript returns error, quiting now ...
        exit
    fi
	echo "INSTALL NEWLY VIM AND COMPILE YCM DONE... "

	# uncomment YouCompleteMe in ~/.vimrc, no need after run 'restore'
	#sed -i --regexp-extended "s/\" (Plugin 'Valloric)/\1/" confirm/_.vimrc

	cat << "_EOF"
------------------------------------------------------
VIM PLUGIN MANAGER INSTRUTION
------------------------------------------------------
__     __  ___   __  __
\ \   / / |_ _| |  \/  |
 \ \ / /   | |  | |\/| |
  \ V /    | |  | |  | |
   \_/    |___| |_|  |_|

Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append `!` to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
_EOF
}

installTmuxPlugins() {
    tmuxInstallScript=~/.tmux/plugins/tpm/bin/install_plugins
    sh -x $tmuxInstallScript
    cat << "_EOF"
------------------------------------------------------
TMUX PLUGIN MANAGER INSTRUCTION
------------------------------------------------------
 _____   __  __   _   _  __  __
|_   _| |  \/  | | | | | \ \/ /
  | |   | |\/| | | | | |  \  /
  | |   | |  | | | |_| |  /  \
  |_|   |_|  |_|  \___/  /_/\_\

Brief help
    send-prefix + I        # install
    send-prefix + U        # update
    send-prefix + Alt-u    # uninstall plugins not on the plugin list

_EOF
}

install() {
    installBone
    installVimPlugins 
    installTmuxPlugins
    cat << _EOF
------------------------------------------------------
VIM path = $vimInstDir/bin/
------------------------------------------------------
_EOF
}

case $1 in 
    'home')
		passedPara="home"
        vimInstDir=$homeInstDir
        install 
    ;;

    'root')
		passedPara="root"
        vimInstDir=$rootInstDir
        install
    ;;

    *)
        usage
        exit
    ;;
esac
