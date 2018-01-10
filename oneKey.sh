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
}

installVim8() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING NEWLY VIM ...
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
    make -j
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now ...
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
    ./install.py --clang-completer
    # check if install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: install fails, quitting now ...
        exit
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING .ycm_extra_conf.py TO HOME ...
------------------------------------------------------
_EOF
    cd $startDir
    sampleDir=./sample
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
    [ctrl +x] +r             # :source ~/.tmux.conf

_EOF
    cat << _EOF
------------------------------------------------------
VIM path = $vimInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
    installBone
    installVimPlugins 
    installVim8
    compileYcm
    installTmuxPlugins
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
