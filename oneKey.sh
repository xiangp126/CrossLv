#!/bin/bash
# COPYRIGHT BY PENG, 2018. XIANGP126@SJTU.EDU.CN.
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory, usually ~/myGit
mainWd=$startDir
# global parameters.
baseDir=~        # .vim/.tmux installation dir
bkPostfix=old
tackleDir=(
    ".vim"
    ".tmux"
)
# VIM install
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
execPrefix=""
# VIM install
#how many cpus os has, used for make -j 
osCpus=1

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

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
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

    #no need to backup after v3.9.1
    #backup .vim/.tmux to .vim.old/.tmux.old
#    for tdir in "${tackleDir[@]}"
#    do
#        #~/.tmux
#        abPath=${baseDir}/${tdir}
#        bkAbPath=${abPath}.${bkPostfix}
#        # remove .old files before mv overwrite.
#        if [[ -d "$bkAbPath" ]]; then
#            rm -rf $bkAbPath
#        fi
#        if [[ -d "$abPath" ]]; then
#            cp -r ${abPath} $bkAbPath 
#        fi
#    done

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
STEP : INSTALLING TMUX-PLUGIN MANAGER
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/tmux-plugins/tpm 
    clonedName=${baseDir}/${tackleDir[1]}/plugins/tpm
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

    cat << _EOF
------------------------------------------------------
REPLACING SOME KEY FILES FIRST ...
------------------------------------------------------
_EOF
    cp -f ./confirm/_.vimrc ${baseDir}/.vimrc
    # replace corsair.vim ahead of whole restore
    mkdir -p ${baseDir}/${tackleDir[0]}/colors
    cp -f ./confirm/_corsair.vim ${baseDir}/${tackleDir[0]}/colors/corsair.vim
}

# install VIM plugins using old version.
installVimPlugins() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING VIM PLUGINS ...
------------------------------------------------------
_EOF
 	#81 Plugin 'Valloric/YouCompleteMe'
	tackleFile=~/.vimrc
	# comment YouCompleteMe in ~/.vimrc
	#it takes too long time, manually compile in cc-ycm.sh
	sed -i --regexp-extended "s/(^Plugin 'Valloric)/\" \1/" $tackleFile

    # source ~/.vimrc if needed
    vim +"source ~/.vimrc" +PluginInstall +qall
	# run restore routine
    sh autoHandle.sh restore
    #load new .bashrc after 'restore' routine
    source ~/.bashrc 2> /dev/null
}

installVim8() {
    #check if vim 8 was installed
    checkCmd=`vim --version | head -n 1 | grep -i "Vi IMproved 8" 2> /dev/null`
    if [[ "$checkCmd" != "" ]]; then
        echo "[Warning]: Vim 8 was already installed, omitting this step ..."
        whereIsVim=`which vim`
        vimInstDir=`echo ${whereIsVim%/bin*}`
        return
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING NEWLY VIM VERSION 8 ...
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

    #find python2 & python3 config dir
	python2Config=`python2-config --configdir 2> /dev/null`
	python3Config=`python3-config --configdir 2> /dev/null`
    if [[ "$python2Config" == "" && "$python3Config" == "" ]]; then
        echo [Error]: Not found python2 or python3, please install either of them ...
        exit
    fi

	./configure --prefix=$vimInstDir \
			--with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python3-config-dir=$python2Config \
            --enable-python3interp=yes \
            --with-python3-config-dir=$python3Config \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
    		--enable-gui=gtk2 \
			--enable-cscope
    make -j $checkOsCpus
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, try below commands ...
        echo "sudo yum -y install perl-devel perl-ExtUtils-Embed"
        exit
    fi
    $execPrefix make install
	# go back to start directory.
    cd $startDir

    cat << _EOF
------------------------------------------------------
INSTALLING VIM DONE ...
`$vimInstDir/bin/vim --version`
vim path = $vimInstDir/bin/
------------------------------------------------------
_EOF

	# uncomment YouCompleteMe in ~/.vimrc, no need after run 'restore'
	#sed -i --regexp-extended "s/\" (Plugin 'Valloric)/\1/" confirm/_.vimrc
}

# compile YouCompleteMe
compileYcm() {
    cmakePath=`which cmake 2> /dev/null`
    if [[ "$cmakePath" == "" ]]; then
        echo [Error]: Missing cmake, please install it first ...
        exit
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : COMPILING YOUCOMPLETEME ...
------------------------------------------------------
_EOF
    # comm attribute for getting source ycm
    repoLink=https://github.com/Valloric
	repoName=YouCompleteMe
    ycmDir=~/.vim/bundle/YouCompleteMe
    if [[ -d $ycmDir ]]; then
        echo [Warning]: already has YCM installed, omitting now ...
    else
        git clone $repoLink/$repoName $ycmDir
        # check if clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quiting now ...
            exit
        fi
    fi
    cd $ycmDir
	git submodule update --init --recursive

    #check if python3 was installed
    pythonExe=python
    whereIsPython3=`which python3 2> /dev/null`
    if [[ "$whereIsPython3" != "" ]]; then
        pythonExe=$whereIsPython3
    fi
    $pythonExe ./install.py --clang-completer

    # check if install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: install fails, quitting now ...
        echo you can try ./sample/linkgcc.sh to link your newly gcc/g++
        exit
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING .ycm_extra_conf.py TO HOME ...
------------------------------------------------------
_EOF
    cd $startDir
    sampleDir=./template
    sampleFile=ycm_extra_conf.py
    echo cp ${sampleDir}/$sampleFile ~/.$sampleFile
    cp ${sampleDir}/$sampleFile ~/.$sampleFile
}

installTmuxPlugins() {
    cmakePath=`which cmake 2> /dev/null`
    if [[ "$cmakePath" == "" ]]; then
        echo [Error]: Missing cmake, please install cmake first ...
        exit
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING TMUX PLUGINS ...
------------------------------------------------------
_EOF
    tmuxInstallScript=~/.tmux/plugins/tpm/bin/install_plugins
    sh -x $tmuxInstallScript

    #no need to recover this after v3.9.1
    #tmux rescover plugin
#     newResurrectDir=~/.tmux/resurrect
#     oldResurrectDir=~/.tmux.old/resurrect
#     if [[ -d "$oldResurrectDir" ]]; then
#         cat << "_EOF"
# ------------------------------------------------------
# COPY BACK TMUX-RESURRECT OLD FILES ...
# ------------------------------------------------------
# _EOF
#         mv $oldResurrectDir $newResurrectDir
#     fi
}

installSummary() {
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
    [ctrl +x] +r           # :source ~/.tmux.conf

_EOF
    cat << _EOF
------------------------------------------------------
VIM path = $vimInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
    checkOsCpus
    installBone
    installTmuxPlugins
    installVimPlugins 
    installVim8
    compileYcm
    installSummary
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
        usage
        exit
    ;;
esac
