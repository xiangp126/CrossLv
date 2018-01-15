#!/bin/bash
# COPYRIGHT BY PENG, 2018. XIANGP126@SJTU.EDU.CN.
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory, usually $HOME/myGit
mainWd=$startDir
#.vim/.tmux installation dir
baseDir=$HOME    
bkPostfix=old
tackleDir=(
    ".vim"
    ".tmux"
)
# common install dir for home | root mode
homeInstDir=$HOME/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
#execute prefix: "" or sudo
execPrefix=""
#required packages install info
#gcc install
gccInstDir=$commInstdir
#python3 install
python3InstDir=$commInstdir
#vim install
vimInstDir=$commInstdir
#cmake install
cmakeInstDir=$commInstdir
#clang install
clangVersion=5.0.1
clangInstDir=$commInstdir/clang-$clangVersion
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
    | - gcc | - python3 | - etc

[SYNOPSIS]
    $exeName [home | root | help]

[DESCRIPTION]
    home -- build required packages to $homeInstDir/
    root -- build required packages to $rootInstDir/

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, make sure sh linked to bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*

_EOF
set +x
    logo
}    

#gcc must support C++11 to compile YCM
checkGccVersion() {
    #loop to find if there exists gcc version meets requirement
    pathLoopLoc=(
        "$HOME/.usr/bin"
        "/usr/local/bin"
        "/usr/bin"
    )
    basicGccVersion=4.8
    CC=""
    for pathLoc in ${pathLoopLoc[@]}
    do
        gccLoc="$pathLoc/gcc"
        if [[ ! -x "$gccLoc" ]]; then
            continue
        fi
        #4.4.7
        gccVersion=`$gccLoc -dumpversion`
        #4.4
        gccV=$(echo $gccVersion | cut -d "." -f 1,2)
        #if found, set env CC/CXX
        if [[ `echo "$gccV >= $basicGccVersion" | bc` -eq 1 ]]; then
            CC=$pathLoc/gcc
            CXX=$pathLoc/c++
        fi
    done
    #check env CC
    which gcc
    if [[ "$CC" == "" ]]; then
        cat << _EOF
[FatalError]: Gcc version < 4.8.0, not support c++11
-----------------------------------------------------
compile gcc(version > 4.8) to /usr/local
--
export CC=/usr/local/bin/gcc
export CXX=/usr/local/bin/c++
export LDFLAGS="-L/usr/local/lib -L/usr/local/lib64" 
-- or
use 'source sample/gen-gccenv.sh root' to export env 
-----------------------------------------------------
_EOF
        exit
    fi

    exit
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
#        #$HOME/.tmux
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
	tackleFile=$HOME/.vimrc
	# comment YouCompleteMe in $HOME/.vimrc
	#it takes too long time, manually compile in cc-ycm.sh
	sed -i --regexp-extended "s/(^Plugin 'Valloric)/\" \1/" $tackleFile

    # source $HOME/.vimrc if needed
    vim +"source $HOME/.vimrc" +PluginInstall +qall
	# run restore routine
    sh autoHandle.sh restore
    #load new .bashrc after 'restore' routine
    source $HOME/.bashrc 2> /dev/null
}

installpython() {
    #find python2 & python3 config dir
	#python2Config=`python2-config --configdir 2> /dev/null`
	python3Config=`python3-config --configdir 2> /dev/null`
    if [[ "$python3Config" != "" ]]; then
        echo [Error]: python3/python3-config already installed, omitting this step ...
        return
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING PYTHON3 ...
------------------------------------------------------
_EOF
    python3InstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'python3'
    wgetLink=https://www.python.org/ftp/python/3.6.4
	tarName=Python-3.6.4.tgz
    untarName=Python-3.6.4

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${tarName}" \
            -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    tar -zxv -f $tarName
    cd $untarName
    ./configure --prefix=$python3InstDir \
                --enable-shared
    make -j $osCpus
	# check if make returns successfully
	if [[ $? != 0 ]]; then
		echo [Error]: make returns error, quiting now ...
		exit
	fi
    $execPrefix make install
    
    cat << _EOF
------------------------------------------------------
INSTALLING python3 DONE ...
`$python3InstDir/bin/python3 --version`
python3 path = $python3InstDir/bin/
------------------------------------------------------
_EOF
}

installvim() {
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
                #--with-python-config-dir=$python2Config \
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
        echo or "sudo apt-get install perl-* lib32ncursesw5-dev"
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

	# uncomment YouCompleteMe in $HOME/.vimrc, no need after run 'restore'
	#sed -i --regexp-extended "s/\" (Plugin 'Valloric)/\1/" confirm/_.vimrc
}

#install newly cmake if needed
installCmake() {
    #check cmake version, if >= 3.4
    cmakePath=`which cmake 2> /dev/null`
    if [[ "$cmakePath" != "" ]]; then
        #cmake version 2.8.12.2
        cmakeVersion=`cmake --version`
        #2.8.12.2
        cmakeVer=`echo ${cmakeVersion} | tr -s "" | cut -d " " -f 3`
        #2.8
        cmakeV=$(echo $cmakeVer | cut -d "." -f 1,2)
        basicCmakeV=3.4
        #if installed cmake already meets the requirement
        if [[ `echo "$cmakeV >= $basicCmakeV" | bc` -eq 1 ]]; then
            echo "[Warning]: system cmake $cmakeVersion  already >= $basicCmakeV ..."
            return
        fi
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING CMAKE 3.10 ...
------------------------------------------------------
_EOF
    cmakeInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'cmake'
    wgetLink=https://cmake.org/files/v3.10
    tarName=cmake-3.10.1.tar.gz
    untarName=cmake-3.10.1

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${tarName}" \
            -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    tar -zxv -f $tarName
    cd $untarName
    ./configure --prefix=$cmakeInstDir

    make -j $osCpus
	# check if make returns successfully
	if [[ $? != 0 ]]; then
		echo [Error]: make returns error, quiting now ...
		exit
	fi
    $execPrefix make install
    
    cat << _EOF
------------------------------------------------------
INSTALLING cmake 3 DONE ...
`$cmakeInstDir/bin/cmake --version`
cmake path = $cmakeInstDir/bin/
------------------------------------------------------
_EOF
}

installClang() {
    cat << "_EOF"
------------------------------------------------------
STEP : PREPARE TO INSTALL CLANG 5 ...
------------------------------------------------------
_EOF
    #clang version, change it if you need other version
    #clangVersion=5.0.1
    clangInstDir=$commin
    $execPrefix mkdir -p $clangInstDir

    cat << "_EOF"
------------------------------------------------------
STEP : DOWNLOADING LLVM 5 ...
------------------------------------------------------
_EOF
    # comm attribute to get source 'llvm'
    #this link is the same for all four packages
    wgetLink=http://releases.llvm.org/$clangVersion
    llvmTarName=llvm-$clangVersion.src.tar.xz
    llvmUntarName=llvm-$clangVersion.src

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $llvmTarName ]]; then
        echo [Warning]: Tar Ball $llvmTarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${llvmTarName}" \
            -O $llvmTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    tar -xv -f $llvmTarName

    cat << "_EOF"
------------------------------------------------------
STEP : DOWNLOADING CFE 5 ...
------------------------------------------------------
_EOF
    # comm attribute to get source 'cfe'
    #cfeWgetLink=http://releases.llvm.org/$clangVersion
    cfeTarName=cfe-$clangVersion.src.tar.xz
    #cfeUntarName=cfe-$clangVersion.src
    cfeUntarName=$llvmUntarName/tools/clang

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $cfeTarName ]]; then
        echo [Warning]: Tar Ball $cfeTarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${cfeTarName}" \
            -O $cfeTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    #mkdir if not exist
    mkdir -p $cfeUntarName
    tar -xv -f $cfeTarName --strip-components=1 -C $cfeUntarName

    cat << "_EOF"
------------------------------------------------------
STEP : DOWNLOADING COMPILER-RT 5 ...
------------------------------------------------------
_EOF
    # comm attribute to get source 'compiler-rt'
    #crtWgetLink=http://releases.llvm.org/$clangVersion
    crtTarName=compiler-rt-$clangVersion.src.tar.xz
    #crtUntarName=compiler-rt-$clangVersion.src
    crtUntarName=$llvmUntarName/projects/compiler-rt

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $crtTarName ]]; then
        echo [Warning]: Tar Ball $crtTarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${crtTarName}" \
            -O $crtTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    #mkdir if not exist
    mkdir -p $crtUntarName
    tar -xv -f $crtTarName --strip-components=1 -C $crtUntarName

    cat << "_EOF"
------------------------------------------------------
STEP : DOWNLOADING CLANG-TOOLS-EXTRA 5 ...
------------------------------------------------------
_EOF
# CMake Error at tools/clang/tools/extra/cmake/Modules/AddCompilerRT.cmake:58 (add_library):
#   add_library cannot create target "RTXray.x86_64" because another target
#   with the same name already exists.  The existing target is created in
#   source directory
#   "/home/corsair/myGit/mylx-vundle/sample/llvm-5.0.1.src/projects/compiler-rt/lib/xray".
#   See documentation for policy CMP0002 for more details.
# Call Stack (most recent call first):
#   tools/clang/tools/extra/lib/xray/CMakeLists.txt:66 (add_compiler_rt_object_libraries)

    # comm attribute to get source 'clang-tools-extra'
    #cteWgetLink=http://releases.llvm.org/$clangVersion
    cteTarName=clang-tools-extra-$clangVersion.src.tar.xz
    #cteUntarName=clang-tools-extra-$clangVersion.src
    cteUntarName=$llvmUntarName/tools/clang/tools/extra

    # rename download package if needed
    cd $startDir
    # check if already has this tar ball.
    if [[ -f $cteTarName ]]; then
        echo [Warning]: Tar Ball $cteTarName already exists, Omitting wget ...
    else
        wget --no-cookies \
            --no-check-certificate \
            --header "Cookie: oraclelicense=accept-securebackup-cookie" \
            "${wgetLink}/${cteTarName}" \
            -O $cteTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quiting now ...
            exit
        fi
    fi
    #mkdir if not exist
    #mkdir -p $cteUntarName
    #tar -xv -f $crtTarName --strip-components=1 -C $cteUntarName

    cat << "_EOF"
------------------------------------------------------
STEP : CHECK AND SET PROPER GCC/G++ VERSION ...
------------------------------------------------------
_EOF
    #set proper gcc/g++ version
    #default gcc/g++ location
    gccLoc=/usr/bin/gcc
    gppLoc=/usr/bin/g++
    #selt-built gcc/g++ location
    homeGccInstDir=$HOME/.usr/bin
    rootGccInstDir=/usr/local/bin
    if [[ -f "$homeGccInstDir/gcc" ]]; then
        gccLoc=$homeGccInstDir/gcc
        gppLoc=$homeGccInstDir/g++
    elif [[ -f "$rootGccInstDir/gcc" ]]; then
        gccLoc=$rootGccInstDir/gcc
        gppLoc=$rootGccInstDir/g++
    fi

    cat << "_EOF"
------------------------------------------------------
STEP : START TO COMPILE CLANG 5 ...
------------------------------------------------------
_EOF
    cd $llvmUntarName
    buildDir=build_dir
    mkdir -p $buildDir
    cd $buildDir
    #cmakePath=$commInstdir/bin/cmake
    cmakePath=`which cmake`
    python3Path=`which python3`
    $cmakePath -G"Unix Makefiles" \
        -DCMAKE_C_COMPILER=$gccLoc \
        -DCMAKE_CXX_COMPILER=$gppLoc \
        -DCMAKE_INSTALL_PREFIX=$clangInstDir \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DPYTHON_EXECUTABLE=$python3Path \
        -DLLVM_INCLUDE_TESTS=OFF \
        $startDir/$llvmUntarName
    make -j $osCpus
	# check if make returns successfully
	if [[ $? != 0 ]]; then
		echo [Error]: make returns error, quiting now ...
		exit
	fi
    #$execPrefix make install
    #need not install, just cp to lib dir is ok
    $execPrefix cp ./lib/libclang.so.5 $commInstdir/lib/libclang.so
    cd $startDir
    
    cat << _EOF
------------------------------------------------------
INSTALLING LLVM DONE ...
libclang.so under $commInstdir/lib/libclang.so
------ tackle below
cd $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd
mv libclang.so.5 libclang.so.5-bak
ln -s $commInstdir/lib/libclang.so libclang.so.5
------------------------------------------------------
_EOF
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
    ycmDir=$HOME/.vim/bundle/YouCompleteMe
    if [[ -d $ycmDir ]]; then
        echo [Warning]: already has YCM repo cloned, omitting now ...
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
    #$pythonExe ./install.py --clang-completer
    ycmBuildDir=ycm_build
    mkdir -p $ycmBuildDir
    cd $ycmBuildDir
    cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=$clangLibPath $ycmDir/third_party/ycmd/cpp

    # check if install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: install fails, quitting now ...
        cat << "_EOF"
        -- native gcc/c++ not support c++11
        Build you new gcc/c++
        source template/gcc_env.sh [MODE]
        -- or md5 mismatch
        rm $HOME/.vim/bundle/YouCompleteMe
        then try again
_EOF
        exit
    fi

    cat << "_EOF"
------------------------------------------------------
LINKING libclang.so FROM SYSTEM-BUILT libclang.so ...
------------------------------------------------------
_EOF
    cd $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd
    mv libclang.so.5 libclang.so.5-bak
    ln -s $commInstdir/lib/libclang.so libclang.so.5

    cat << "_EOF"
------------------------------------------------------
INSTALLING .ycm_extra_conf.py TO HOME ...
------------------------------------------------------
_EOF
    cd $startDir
    sampleDir=./template
    sampleFile=ycm_extra_conf.py
    echo cp ${sampleDir}/$sampleFile $HOME/.$sampleFile
    cp ${sampleDir}/$sampleFile $HOME/.$sampleFile
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
    tmuxInstallScript=$HOME/.tmux/plugins/tpm/bin/install_plugins
    sh -x $tmuxInstallScript

    #no need to recover this after v3.9.1
    #tmux rescover plugin
#     newResurrectDir=$HOME/.tmux/resurrect
#     oldResurrectDir=$HOME/.tmux.old/resurrect
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
    [ctrl +x] +r           # :source $HOME/.tmux.conf

_EOF
    cat << _EOF
------------------------------------------------------
VIM path = $vimInstDir/bin/
------------------------------------------------------
_EOF
}

install() {
    checkGccVersion
    #checkOsCpus
    #installBone
    #installTmuxPlugins
    #installVimPlugins 
    #installpython
    #installvim
    installCmake
    #installClang
    #compileYcm
    #installSummary
}

case $1 in 
    'home')
		commInstdir=$homeInstDir
        execPrefix=""
        install 
    ;;

    'root')
        #run fix dependency routine as has root privilege
        sh -x tools/osFixDepends.sh
		commInstdir=$rootInstDir
        execPrefix=sudo
        install
    ;;

    *)
        usage
        exit
    ;;
esac
