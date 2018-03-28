#!/bin/bash
# COPYRIGHT BY PENG, 2018. XIANGP126@SJTU.EDU.CN.
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0); pwd)
# .vim/.tmux config files location
baseDir=$HOME
tackleDir=(
    ".vim"
    ".tmux"
)
bkPostfix=old
# common install dir for home | root mode
homeInstDir=$HOME/.usr
rootInstDir=/usr/local
# installation mode, default is home
instMode=home
commInstdir=$homeInstDir
# execute prefix: "" or sudo
execPrefix=""
# if first run this script, it'll generate mRunFlagFile
# if checked has this file, will skip many install
mRunFlagFile=.MORETIME.txt
# ubuntu | centos | macos
platOsType=ubuntu
# required packages install info
# gcc install
gccInstDir=$commInstdir
# silver searcher install
ackInstDir=$commInstdir
# universal ctags install
uCtagsInstDir=$commInstdir
# python3 install
python3InstDir=$commInstdir
python3Path=`which python3 2> /dev/null`
# vim install
vimInstDir=$commInstdir
# cmake install
cmakeInstDir=$commInstdir
cmakePath=`which cmake 2> /dev/null`
# clang install
clangVersion=5.0.1
# install clang into a separate dir
clangSubDir=clang-$clangVersion
clangInstDir=$commInstdir/$clangSubDir
# how many cpus os has, used for make -j
cpuCoreNum=1
# store all downloaded packages here
downloadPath=$mainWd/downloads
# dir storing tracked files
trackDir=./track-files
# git repo need update
needPull=false

logo() {
    cat << "_EOF"
                        _
  ___ _ __ ___  ___ ___| |_   __
 / __| '__/ _ \/ __/ __| \ \ / /
| (__| | | (_) \__ \__ \ |\ V /
 \___|_|  \___/|___/___/_| \_/

_EOF
}

printNotePage() {
    cat << "_EOF"
------------------------------------------------------
VIM PLUGIN MANAGER INSTRUTION
------------------------------------------------------
Brief help
    :PluginList       - lists configured plugins
    :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    :PluginSearch foo - searches for foo; append `!` to refresh local cache
    :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

------------------------------------------------------
TMUX PLUGIN MANAGER INSTRUCTION
------------------------------------------------------
Brief help
    send-prefix + I        # install
    send-prefix + U        # update
    send-prefix + Alt-u    # uninstall plugins not on the plugin list
    [ctrl +x] +r           # :source $HOME/.tmux.conf

------------------------------------------------------
EXECUTE VIM COMMANDS THROUGH COMMAND LINE
------------------------------------------------------
Brief help
    vim +PluginInstall +qall
    # equals $ vim and then :PluginInstall and then :qall
    vim +"help tags"
    # equals $ vim and then :help tags
----------------- END OF THIS NOTE -------------------
_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- onekey to setup my working environment
             | - vim | - plugins -- youcompleteme -- supertab -- vim-snippets
                       -- ultisnips -- nerdtree -- auto-pairs -- fzf
                     | - python3 | - etc
             | - tmux | - plugins | - etc

[SYNOPSIS]
    sh $exeName [home | root | help]

[DESCRIPTION]
    home -- build required packages to $homeInstDir/
    root -- build required packages to $rootInstDir/

[TROUBLESHOOTING]
    sudo ln -s /bin/bash /bin/sh, ensure /bin/sh was linked to /bin/bash.
    $ ll /bin/sh lrwxrwxrwx 1 root root 9 Dec  7 01:00 /bin/sh -> /bin/bash*
_EOF
    logo
}

# compare software version
cmpSoftVersion() {
    set +x
    # usage: cmpSoftVersion TrueVer $BasicVer , format xx.xx(3.10)
    # return '1' if $1 >= $2
    # return '0' else
    leftVal=$1
    rightVal=$2
    if [[ $leftVal == "" || $rightVal == "" ]]; then
        echo Error: syntax not match, please check
        exit 255
    fi

    # with max loop
    for (( i = 0; i < 5; i++ )); do
        if [[ $leftVal == "0" && $rightVal == "0" ]]; then
            break
        fi
        leftPartial=$(echo ${leftVal%%.*})
        rightPartial=$(echo ${rightVal%%.*})
        if [[ $(echo "$leftPartial > $rightPartial" | bc ) -eq 1 ]]; then
            set -x
            return 1
        elif [[ $(echo "$leftPartial < $rightPartial" | bc ) -eq 1 ]]; then
            set -x
            return 0
        fi
        # update leftVal and rightVal for next loop compare
        if [[ ${leftVal#*.} == $leftVal ]]; then
            leftVal='0'
        else
            leftVal=${leftVal#*.}
        fi
        if [[ ${rightVal#*.} == $rightVal ]]; then
            rightVal='0'
        else
            rightVal=${rightVal#*.}
        fi
    done

    set -x
    return 1
}

installBashCompletion() {
    cat << _EOF
------------------------------------------------------
INSTALLING EXTRA BASH COMPLETION FOR GIT, TMUX, ETC
------------------------------------------------------
_EOF
    cd $mainWd
    # extra bash completion dir
    copyFromDir=./completion
    # dir to install extra bash comp
    extraBashCompInstDir=$HOME/.completion.d
    mkdir -p $extraBashCompInstDir
    for file in `find $copyFromDir -regex ".*.bash" -type f`
    do
        onlyFileName=${file##*/}
        if [[ ! -f $extraBashCompInstDir/$onlyFileName ]]; then
            cp $file $extraBashCompInstDir/
        fi
    done
    retVal=$?
    if [[ $retVal != 0 ]]; then
        echo [Warning]: copy extra bash completion files return with value $retVal
    fi

    # bash-completion bash-completion - programmable completion for the bash shell
    whereIsLibBashComp=`pkg-config --list-all | grep -i bash-completion \
        2> /dev/null`
    if [[ $whereIsLibBashComp != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING STANDARD BASH-COMPLETION FOR SED, FIND, ETC
------------------------------------------------------
_EOF
    bashCompInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source
    wgetLink=http://archive.ubuntu.com/ubuntu/pool/main/b/bash-completion
    tarName=bash-completion_2.1.orig.tar.bz2
    untarName=bash-completion-2.1

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    if [[ ! -d $untarName ]]; then
        tar -jxv -f $tarName
    fi
    cd $untarName
    ./configure --prefix=$bashCompInstDir
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [error]: make returns error, quitting now
        exit
    fi

    $execPrefix make install
    if [[ $? != 0 ]]; then
        echo [error]: make install returns error, quitting now
        exit
    fi

    checkName=bash_completion.sh
    ls -l $checkName
    if [[ $? != 0 ]]; then
        echo [error]: $checkName did not exist, quitting now
        exit
    fi
    cp bash_completion.sh $HOME/.bash_completion.sh

    # copy bash-completion.pc to standard PKG_CONFIG_PATH search path
    itOriPkgPath=$bashCompInstDir/share/pkgconfig/bash-completion.pc
    itDstPkgPath=$bashCompInstDir/lib/pkgconfig/
    $execPrefix cp $itOriPkgPath $itDstPkgPath

    ls -l $itDstPkgPath/bash-completion.pc
    if [[ $? != 0 ]]; then
        echo [error]: copy bash-compile.pc failed, quitting now
        exit
    fi
}

installFonts() {
    # only platform used for Desktop will install extra fonts
    if [[ $platOsType == 'redhat' ]]; then
        return
    fi

    cat << _EOF
------------------------------------------------------
INSTALLING WONDERFUL PROGRAMMING FONTS
------------------------------------------------------
_EOF
    # check if trylly need do fc-cache
    needUpdateCnt=0

    cd $mainWd
    copyFromDir=./fonts
    fontsInstDir=$HOME/.local/share/fonts
    if [[ $platOsType == 'macos' ]]; then
        fontsInstDir=$HOME/Library/Fonts
    fi
    mkdir -p $fontsInstDir

    for file in `find $copyFromDir -regex '.*.tt[f|c]$' -type f`
    do
        fontName=${file##*/}
        fontName=${fontName%.*}
        checkCmd=`fc-list | grep -i $fontName`
        if [[ $checkCmd == "" ]]; then
            ((needUpdateCnt++))
            cp $file $fontsInstDir
            retVal=$?
            if [[ $retVal != 0 ]]; then
                echo [Warning]: copy extra bash completion files return with value $retVal
            fi
        fi
    done

    cat << "_EOF"
------------------------------------------------------
INSTALLING POWERLINE SYMBOLS FOR AIRLINE
------------------------------------------------------
_EOF
    cd $mainWd/fonts/powerline-symbols
    powerSymbolConf=10-powerline-symbols.conf
    powerSymbolOtf=PowerlineSymbols.otf

    checkCmd=`fc-list | grep -i PowerlineSymbols`
    if [[ $checkCmd == "" ]]; then
        ((needUpdateCnt++))
        if [[ ! -f $fontsInstDir/$powerSymbolOtf ]]; then
            cp $powerSymbolOtf $fontsInstDir
        fi
    fi

    fontsConfDir=$HOME/.config/fontconfig/conf.d/
    mkdir -p $fontsConfDir
    if [[ ! -f $fontsConfDir/$powerSymbolConf ]]; then
        cp $powerSymbolConf $fontsConfDir
    fi

    # update font cache as a whole
    if [[ $needUpdateCnt != 0 ]]; then
        fc-cache -fv $fontsInstDir
    fi
    cat << "_EOF"
------------------------------------------------------
FONT -> monaco 17pt
NON-ASCII font PowerlineSymbols 14pt
--- usually need not do
If custom symbols still cannot be seen then try
closing all instances of the terminal emulator.
Restarting X may be needed for the changes to take effect.
------------------------------------------------------
_EOF

    return 0
    cat << "_EOF"
------------------------------------------------------
INSTALLING MANY POWERLINE-PACHED FONTS
------------------------------------------------------
_EOF
    pFontClonePath=https://github.com/powerline/fonts
    clonedName=fonts

    # rename download package
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName/ already exists
    else
        git clone $pFontClonePath $clonedName --depth=1
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi

    # install
    cd $clonedName
    sh -x install.sh
    fc-cache -fv $fontsInstDir
}

# gcc must support C++11 to compile YCM
checkGccVersion() {
    # loop to find if there exists gcc and version meets requirement
    pathLoopLoc=(
        "$HOME/.usr/bin"
        "/usr/local/bin"
        "/usr/bin"
    )
    CC=""
    for pathLoc in ${pathLoopLoc[@]}
    do
        if [[ ! -d $pathLoc ]]; then
            continue
        fi
        gccLoc="$pathLoc/gcc"
        if [[ ! -x "$gccLoc" ]]; then
            continue
        fi

        # check if gcc found version matches
        basicGccV=4.8
        # 4.4.7
        gccV=`$gccLoc -dumpversion`
        cmpSoftVersion $gccV $basicGccV
        if [[ $? == '1' ]]; then
            # found one matchs
            CC=$pathLoc/gcc
            CXX=$pathLoc/c++
            break
        fi
    done

    # compiling new gcc to support c++11
    if [[ "$CC" == "" ]]; then
#         cat << _EOF
# [FatalWarning]: Gcc version < 4.8.0, not support c++11
# -----------------------------------------------------
# FOR EXAMPLE: compile gcc(version > 4.8) to /usr/local
# --
# export CC=/usr/local/bin/gcc
# export CXX=/usr/local/bin/c++
# # export LDFLAGS="-L/usr/local/lib -L/usr/local/lib64"
# -- or
# use 'source sample/gen-gccenv.sh root' to export env
# -----------------------------------------------------
# _EOF
        return 0
    else
        return 1
    fi
}

installGcc() {
    # if gcc version meets requirement, return 0
    checkGccVersion
    retVal=$?
    if [[ $retVal == '1' ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING GCC 5
------------------------------------------------------
_EOF
    gccInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'gcc'
    wgetLink=http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-5.5.0
    tarName=gcc-5.5.0.tar.gz
    untarName=gcc-5.5.0

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    if [[ ! -d $untarName ]]; then
        tar -zxv -f $tarName
    fi
    cd $untarName
    # download extra packages fixing depends
    ./contrib/download_prerequisites
    # for ubuntu has privilege, use apt-get install libmpc-dev fix error.
    if [[ $? != 0 ]]; then
        echo [error]: fix depends returns error, quitting now
        echo Ubuntu use apt-get install libmpc-dev may fix error
        exit
    fi
    gccBuildDir=build_dir
    mkdir -p $gccBuildDir
    cd $gccBuildDir
    make distclean 2> /dev/null
    # --enable-languages=c,c++
    ../configure --prefix=$gccInstDir \
                 --disable-multilib \
                 --enable-checking=release
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [error]: make returns error, quitting now
        exit
    fi

    $execPrefix make install
    # check if make install returns successfully
    if [[ $? != 0 ]]; then
        echo [error]: make install returns error, quitting now
        exit
    fi

cat << _EOF
------------------------------------------------------
SETTING CC/CXX COMPILE VARIABLES
------------------------------------------------------
_EOF
    CC=$gccInstDir/bin/gcc
    CXX=$gccInstDir/bin/c++

    cat << _EOF
------------------------------------------------------
INSTALLING GCC DONE
`$gccInstDir/bin/gcc --version`
GCC/C++/G++ path = $gccInstDir/bin/
------------------------------------------------------
_EOF
}

checkCpuCoreNum() {
    if [[ "`which lscpu 2> /dev/null`" == "" ]]; then
        # echo [Warning]: OS has no lscpu installed, omitting this
        # macos did not has lscpu, so remomve [job] restrict
        cpuCoreNum=""
        return
    fi
    # set new os cpus
    cpuCoreNum=`lscpu | grep -i "^CPU(s):" | tr -s " " | cut -d " " -f 2`
    if [[ "$cpuCoreNum" == "" ]]; then
        cpuCoreNum=1
    fi
    # echo "OS has CPU(S): $cpuCoreNum"
}

# install vim and tmux
installBone() {
    if [ ! -d $baseDir ]; then
        echo FatalError: Could not found $baseDir/, please check it
        exit 255
    fi

    cd $mainWd
    cat << _EOF
------------------------------------------------------
RUN BACKUP ROUTINE FIRST
------------------------------------------------------
_EOF
    sh autoHandle.sh backup

cat << "_EOF"
------------------------------------------------------
INSTALLING MANAGER FOR VIM PLUGINS
------------------------------------------------------
_EOF
    # only download one file from this git repo
    vmDownPath=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vmInstDir=$HOME/.vim/autoload
    vmInstPath=$vmInstDir/plug.vim

    # check if target file already exists
    if [[ -f $vmInstPath ]]; then
        echo [Warning]: target $vmInstPath already exists
    else
        curlPath=`which curl 2> /dev/null`
        if [[ $curlPath == "" ]]; then
            # did not has curl, use wget instead
            mkdir -p $vmInstDir
            wget $vmDownPath -O $vmInstPath
            if [[ $? != 0 ]]; then
                echo [Error]: wget returns error, quitting now
                exit 255
            fi
        else
            curl -fLo $vmInstPath --create-dirs $vmDownPath
            # check if git returns successfully
            if [[ $? != 0 ]]; then
                echo "[Error]: curl returns error, quitting now "
                exit 255
            fi
        fi
    fi

    cat << "_EOF"
------------------------------------------------------
INSTALLING MANAGER FOR TMUX PLUGINS
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/tmux-plugins/tpm
    clonedName=${baseDir}/${tackleDir[1]}/plugins/tpm
    # check if target directory already exists
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName already exists
    else
        git clone $gitClonePath $clonedName
        # check if git returns successfully
        if [[ $? != 0 ]]; then
            echo "[Error]: git returns error, quitting now "
            exit
        fi
    fi
    cat << _EOF
------------------------------------------------------
PLACING NEW .VIMRC IN PLACE
------------------------------------------------------
_EOF
    cd $mainWd
    # let .vimrc in place ahead
    cp $trackDir/vimrc $baseDir/.vimrc
    cat << _EOF
------------------------------------------------------
COMMENT ON COLORSCHEME IN .VIMRC
------------------------------------------------------
_EOF
    # comment on color scheme line if default color not found
    defColorPath=$HOME/.vim/colors/darkcoding.vim
    matchStr=':colorscheme'
    if [[ ! -f $defColorPath ]]; then
        sed -i --regexp-extended \
            "s/$matchStr/\" $matchStr/" $HOME/.vimrc
    else
        # replace exist colorscheme to darkcoding
        replacedTo=darkcoding
        sed -i --regexp-extended \
            "/$matchStr/c $matchStr $replacedTo" $HOME/.vimrc
        # check return status
        retVal=$?
        if [[ $retVal != 0 ]]; then
            echo "[Warning]: replace color scheme returns $retVal "
        fi
    fi

    # call sub-functions to install each module
    installTmuxPlugins
    installVimPlugins
    installBashCompletion
    installFonts
}

installTmuxPlugins() {
    cat << "_EOF"
------------------------------------------------------
INSTALLING TMUX PLUGINS
------------------------------------------------------
_EOF
    tmuxInstallScript=$HOME/.tmux/plugins/tpm/bin/install_plugins
    sh -x $tmuxInstallScript
}

# install VIM plugins using old version.
installVimPlugins() {
    cat << "_EOF"
------------------------------------------------------
INSTALLING VIM PLUGINS
------------------------------------------------------
_EOF
    cd $mainWd
    # 81 Plugin 'Valloric/YouCompleteMe'
    tackleFile=$HOME/.vimrc
    # comment YouCompleteMe in $HOME/.vimrc
    # it takes too long time, manually compile in cc-ycm.sh
    sed -i --regexp-extended "s/(^Plug 'Valloric)/\" \1/" $tackleFile

    # source $HOME/.vimrc if needed
    vim +"source $HOME/.vimrc" +PlugInstall +qall

    cat << "_EOF"
------------------------------------------------------
RUN RESTORE ROUTINE NOW
------------------------------------------------------
_EOF
    sh autoHandle.sh restore
    # load new .bashrc after 'restore' routine
    source $HOME/.bashrc 2> /dev/null

    # extra install actions for vim plugins
    doExtraForFzf
}

installLibpcre() {
    whereIsLibpcre=`pkg-config --libs libpcre 2> /dev/null`
    if [[ $whereIsLibpcre != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING LIBPCRE
------------------------------------------------------
_EOF
    libpcreInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    wgetLink=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
    tarName=pcre-8.41.tar.gz
    untarName=pcre-8.41

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if already untared
    if [[ -d $untarName ]]; then
        echo [Warning]: untarname $untarName already exists
    else
        tar -zxv -f $tarName
    fi
    cd $untarName
    ./configure --prefix=$python3InstDir \
                --enable-shared
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now
        exit
    fi

    $execPrefix make install
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install returns error, quitting now
        exit
    fi
}

installLiblzma() {
    whereIsLiblzma=`pkg-config --libs liblzma 2> /dev/null`
    if [[ $whereIsLiblzma != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING XZ-UTILS (LIBLZMAI)
------------------------------------------------------
_EOF
    liblzmaInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    wgetLink=http://cdn-fastly.deb.debian.org/debian/pool/main/x/xz-utils
    tarName=xz-utils_5.2.2.orig.tar.xz
    untarName=xz-5.2.2

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if already untared
    if [[ -d $untarName ]]; then
        echo [Warning]: untarName $untarName already exists
    else
        tar -xv -f $tarName
    fi
    cd $untarName
    ./configure --prefix=$python3InstDir \
                --enable-shared
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now
        exit
    fi

    $execPrefix make install
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install returns error, quitting now
        exit
    fi
}

installRust() {
    cargoPath=`which cargo 2> /dev/null`
    if [[ $cargoPath != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING RUST (CARGO)
------------------------------------------------------
_EOF
    rustUpShell=sh.rustup.rs
    cd $downloadPath
    if [[ ! -x $rustUpShell ]]; then
        wget https://sh.rustup.rs -O $rustUpShell
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, please check it
            exit
        fi
        chmod +x $rustUpShell
        # ensure only sed 'add' once
        sed -i "2a set -x" $rustUpShell
    fi
    ./$rustUpShell -y
    if [[ $? != 0 ]]; then
        echo [Error]: rust setup failed, please check it
        exit
    fi
    cargoPath=$HOME/.cargo/bin/cargo
    $cargoPath --version
    if [[ $? != 0 ]]; then
        echo [Error]: cargo install error, quitting now
        exit
    fi
}

installRipGrep() {
    rgPath=`which rg 2> /dev/null`
    if [[ $rgPath != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING RIPGREP -- REPLACEMENT of GREP
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/BurntSushi/ripgrep
    clonedName=ripgrep

    cd $downloadPath
    # check if already has this git repo
    if [[ ! -d $clonedName ]]; then
        git clone $gitClonePath $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi

    if [[ $needPull == 'true' ]]; then
        git pull
    fi
    # build routine
    cd $clonedName
    $cargoPath build --release
    if [[ $? != 0 ]]; then
        echo [Error]: ripgrep build returns error, quitting now
        exit
    fi
    $cargoPath install
    if [[ $? != 0 ]]; then
        echo [Error]: ripgrep install returns error, quitting now
        exit
    fi

    rgPath=$HOME/.cargo/bin/rg
    $rgPath --version
    if [[ $? != 0 ]]; then
        echo [Error]: ripgrep run error, quitting now
        exit
    fi
}

# replacement of gnu find
installFd() {
    fdPath=`which fd 2> /dev/null`
    if [[ $fdPath != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING FD -- REPLACEMENT of FIND
------------------------------------------------------
_EOF
    gitClonePath=https://github.com/sharkdp/fd
    clonedName=fd-find

    cd $downloadPath
    # check if already has this git repo
    if [[ ! -d $clonedName ]]; then
        git clone $gitClonePath $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi

    if [[ $needPull == 'true' ]]; then
        git pull
    fi
    # build routine
    cd $clonedName
    $cargoPath build --release
    if [[ $? != 0 ]]; then
        echo [Error]: fd-find build returns error, quitting now
        exit
    fi
    $cargoPath install
    if [[ $? != 0 ]]; then
        echo [Error]: fd-find install returns error, quitting now
        exit
    fi

    fdPath=$HOME/.cargo/bin/fd
    $fdPath --version
    if [[ $? != 0 ]]; then
        echo [Error]: fd-find run error, quitting now
        exit
    fi
}

# install silver searcher
installSilverSearcher() {
    agPath=`which ag 2> /dev/null`
    if [[ $agPath != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING SILVER SEARCHER (ALIAS TO ACK)
------------------------------------------------------
_EOF
    if [[ $execPrefix != 'sudo' ]]; then
        # if has no root privilege need manual compile them
        installLibpcre
        installLiblzma
    fi
    ackInstDir=$commInstdir
    gitClonePath=https://github.com/ggreer/the_silver_searcher
    clonedName=the_silver_searcher
    cd $downloadPath
    if [[ -d "$clonedName" ]]; then
        echo [Warning]: clonedName $clonedName/ already exists
    else
        git clone $gitClonePath
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quiting now
            exit
        fi
    fi

    cd $clonedName
    # checkout to latest released tag
    git pull
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    if [[ "$latestTag" != "" ]]; then
        git checkout $latestTag
    fi
    # begin to build
    ./autogen.sh
    ./configure --prefix=$ackInstDir
    if [[ $? != 0 ]]; then
        echo [Error]: ./configure returns error, quitting now ...
        exit
    fi
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now ...
        exit
    fi

    $execPrefix make install
    # check if make install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install returns error, quitting now ...
        exit 255
    fi
    agPath=$ackInstDir/bin/ag
}

# command-line fuzzy finder
doExtraForFzf() {
    fzfPath=`which fzf 2> /dev/null`
    if [[ $fzfPath != "" ]]; then
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING COMMAND-LINE FUZZY FINDER FZF
------------------------------------------------------
_EOF
    # Exp: /usr/local/fzf
    fzfInstDir=$HOME/.vim/bundle/fzf
    if [[ ! -d $fzfInstDir ]]; then
        echo 'Error: not found plugin fzf installed, please check it'
        exit 255
    fi

    cd $fzfInstDir
    sh install --bin
    if [[ $? != 0 ]]; then
        echo [Error]: install fzf returns error, quitting now ...
        exit
    fi

    cat << "_EOF"
------------------------------------------------------
MAKING SOFT LINK OF FZF INTO $commInstdir/
------------------------------------------------------
_EOF
    linkFromDir=bin
    for file in `find $linkFromDir -type f`; do
        $execPrefix ln -sf $fzfInstDir/$file $commInstdir/bin/
    done

    if [[ $? != 0 ]]; then
        echo [Error]: make fzf soft link return error, quitting now ...
        exit 255
    fi
    # change fzf-tmux to tfzf
    cd $commInstdir/bin
    if [[ -f fzf-tmux ]]; then
        $execPrefix ln -sf fzf-tmux tzf
    fi
    fzfPath=$commInstdir/bin/fzf
}

installuCtags() {
    # check if already installed
    checkCmd=`ctags --version | grep -i universal 2> /dev/null`
    if [[ $checkCmd != "" ]]; then
        uCtagsPath=`which ctags`
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING UNIVERSAL CTAGS
------------------------------------------------------
_EOF
    uCtagsInstDir=$commInstdir
    cd $downloadPath
    clonedName=ctags
    if [[ -d "$clonedName" ]]; then
        echo [Warning]: clonedName $clonedName/ already exists
    else
        git clone https://github.com/universal-ctags/ctags
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quiting now
            exit
        fi
    fi
    cd $clonedName
    ./autogen.sh
    ./configure --prefix=$uCtagsInstDir
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now ...
        exit
    fi
    $execPrefix make install
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install returns error, quitting now ...
        exit 255
    fi
    uCtagsPath=$uCtagsInstDir/bin/ctags
}

installPython3() {
    # install python3, no matter if installed python2
    # method one -> locate  | sudo updatedb
    python3Path=`which python3 2> /dev/null`
    if [[ "$python3Path" != "" ]]; then
        whereIsLocate=`which locate 2> /dev/null`
        if [[ "$whereIsLocate" != "" ]]; then
            # Python 3.5.2
            python3Version=`python3 --version`
            # 3.5.2
            python3Ver=$(echo $python3Version | tr -s "" | cut -d " " -f 2)
            # 3.5
            python3V=$(echo $python3Ver | cut -d "." -f 1,2)
            # libpython3.5m.so
            libPython3Name=libpython${python3V}m.so
            # may need run 'sudo updatedb'
            libPython3Path=$(locate $libPython3Name | head -n 1 2> /dev/null)

            # check if any error occurs
            if [[ "$libPython3Path" == "" || "$?" != 0  ]]; then
                echo "[Warning]: locate checking python3 path/lib failed, start find checking "
            else
                echo [Warning]: python3/lib already installed
                return
            fi
        fi

        # method two -> find
        # python3 Python - Python library
        # sudo updatedb
        whereIsLibPython3=`pkg-config --list-all | grep -i python3 2> /dev/null`
        if [[ "$python3Path" != "" && "$whereIsLibPython3" != "" ]]; then
            # -L/usr/local/lib
            python3LibL=`pkg-config --libs-only-L python3`
            # -lpython3.6m
            python3Libl=`pkg-config --libs-only-l python3`
            libPython3Path="$(echo ${python3LibL#*L})/lib$(echo ${python3Libl#*-l}).so"
            ls -l $libPython3Path

            # check if any error occurs
            if [[ $? != 0 ]]; then
                echo "[Warning]: find checking python3 path/lib failed, re-install python3 "
            else
                echo [Warning]: python3/lib already installed
                return
            fi
        fi
    fi

    cat << "_EOF"
------------------------------------------------------
INSTALLING PYTHON3
------------------------------------------------------
_EOF
    python3InstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'python3'
    wgetLink=https://www.python.org/ftp/python/3.6.4
    tarName=Python-3.6.4.tgz
    untarName=Python-3.6.4

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if already untared
    if [[ -d $untarName ]]; then
        echo [Warning]: found $untarName
    else
        tar -zxv -f $tarName
    fi
    cd $untarName
    ./configure --prefix=$python3InstDir \
                --enable-shared
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now
        exit
    fi

    $execPrefix make install
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install returns error, quitting now
        exit
    fi
    python3Path=$python3InstDir/bin/python3
    libPython3Path=$python3InstDir/lib/libpython3.6m.so
    if [[ ! -f $libPython3Path ]]; then
        echo [Error]: can not find lib-python3, quitting now
        exit
    fi

    cat << _EOF
------------------------------------------------------
INSTALLING python3 DONE
`$python3InstDir/bin/python3 --version`
python3 path = $python3InstDir/bin/python3
libpython3 path = $libPython3Path
------------------------------------------------------
_EOF
}

installvim() {
    # check if vim 8 was installed
    checkCmd=`vim --version | head -n 1 | grep -i "Vi IMproved 8" 2> /dev/null`
    if [[ "$checkCmd" != "" ]]; then
        echo "[Warning]: Vim 8 was already installed"
        vimPath=`which vim`
        return
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING NEWLY VIM VERSION 8
------------------------------------------------------
_EOF
    vimInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'vim'
    vimClonePath=https://github.com/vim/vim
    clonedName=vim
    checkoutVersion=v8.0.1450

    # rename download package
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName/ already exists
    else
        git clone ${vimClonePath} $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi

    cd $clonedName
    # checkout to latest released tag
    git checkout master
    git pull
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    if [[ "$latestTag" != "" ]]; then
        git checkout $latestTag
    fi

    # clean before ./configure
    # make distclean

    # find python2 & python3 config dir
    python2Config=`python2-config --configdir 2> /dev/null`
    python3Config=`python3-config --configdir 2> /dev/null`
    if [[ "$python2Config" == "" && "$python3Config" == "" ]]; then
        echo [Error]: Not found python2 or python3, please install either of them
        exit
    fi

    # https://stackoverflow.com/questions/10101488/cut-to-the-system-clipboard-from-vim-on-ubuntu
    # fix issue for ubuntu/vim no X11 support after trully has installed associage packages
    find . -name config.cache -delete 2> /dev/null

    # --with-python-config-dir=$python2Config
    ./configure --prefix=$vimInstDir \
                --with-features=huge \
                --enable-multibyte \
                --enable-rubyinterp=yes \
                --enable-pythoninterp=yes \
                --enable-python3interp=yes \
                --with-python3-config-dir=$python3Config \
                --enable-perlinterp=yes \
                --enable-luainterp=yes \
                --enable-gui=gtk2 \
                --enable-cscope
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, try below commands
        echo "sudo yum -y install perl-devel perl-ExtUtils-Embed"
        echo or "sudo apt-get install perl-* lib32ncursesw5-dev"
        exit
    fi
    $execPrefix make install
    if [[ $? != 0 ]]; then
        echo [error]: make install returns error, quitting now
        exit
    fi
    vimPath=$vimInstDir/bin/vim
    # uncomment YouCompleteMe in $HOME/.vimrc, no need after run 'restore'
    # sed -i --regexp-extended "s/\" (Plugin 'Valloric)/\1/" confirm/_.vimrc
}

installTmux() {
    # check tmux version, if >= 2.5
    tmuxPath=`which tmux 2> /dev/null`
    if [[ "$tmuxPath" != "" ]]; then
        tmuxVersion=`tmux -V | cut -d ' ' -f 2`
        basicTmuxV=2.5
        cmpSoftVersion $tmuxVersion $basicTmuxV
        if [[ $? == '1' || "$tmuxVersion" == "master" ]]; then
            return
        fi
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING NEWLY TMUX VERSION 2.6
------------------------------------------------------
_EOF
    tmuxInstDir=$commInstdir
    $execPrefix mkdir -p $tmuxInstDir
    # comm attribute to get source 'let-tmux'
    tmuxClonePath=https://github.com/xiangp126/let-tmux
    clonedName=let-tmux

    # rename download package
    cd $downloadPath
    # check if already has this repository.
    if [[ -d $clonedName ]]; then
        echo [Warning]: target $clonedName/ already exists
    else
        git clone $tmuxClonePath $clonedName
        # check if git clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi
    cd $clonedName
    sh oneKey.sh $instMode
    tmuxPath=$tmuxInstDir/bin/tmux
}

# install newly cmake if needed
installCmake() {
    # check cmake version, if >= 3.0
    cmakePath=`which cmake 2> /dev/null`
    if [[ "$cmakePath" != "" ]]; then
        # cmake version 2.8.12.2
        cmakeVersion=`cmake --version`
        # 2.8.12.2
        cmakeV=`echo ${cmakeVersion} | tr -s "" | cut -d " " -f 3`
        basicCmakeV=3.4
        cmpSoftVersion $cmakeV $basicCmakeV
        if [[ $? == '1' ]]; then
            return
        fi
    fi
    cat << "_EOF"
------------------------------------------------------
INSTALLING CMAKE 3.10
------------------------------------------------------
_EOF
    cmakeInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'cmake'
    wgetLink=https://cmake.org/files/v3.10
    tarName=cmake-3.10.1.tar.gz
    untarName=cmake-3.10.1

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $tarName ]]; then
        echo [Warning]: Tar Ball $tarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${tarName}" \
             -O $tarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    tar -zxv -f $tarName
    cd $untarName
    ./configure --prefix=$cmakeInstDir

    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make cmake failed, quitting now
        exit 255
    fi
    $execPrefix make install
    # check if make install returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: install cmake failed, try link it soft
        cmakeRealPath=`pwd`/bin/cmake
        $execPrefix ln -sf $cmakeRealPath $cmakeInstDir/bin
        if [[ $? != 0 ]]; then
            echo [FatalError]: soft link cmake also failed, quitting now
        fi
    fi
    cmakePath=$cmakeInstDir/bin/cmake
    cat << _EOF
------------------------------------------------------
INSTALLING CMAKE 3 DONE
$($cmakeInstDir/bin/cmake --version)
cmake path = $cmakeInstDir/bin/
$(ls -l $cmakePath)
------------------------------------------------------
_EOF
}

installClang() {
    libClangName="libclang.so"
    # loop to find system installed libclang.so
    pathLoopLoc=(
        # ~/.usr/clang-5.0.1
        "$commInstdir/$clangSubDir"
        "$rootInstDir/$clangSubDir"
        "$HOME/.usr/lib"
        "$HOME/.usr/lib64"
        "/usr/local/lib"
        "/usr/local/lib64"
        "/usr/lib"
        "/usr/lib64"
    )
    libClangPath=""
    for pathLoc in ${pathLoopLoc[@]}
    do
        if [[ ! -d $pathLoc ]]; then
            continue
        fi
        libClangPath=`find $pathLoc -name libclang.so | head -n 1 2> /dev/null`
        if [[ "$libClangPath" != "" ]]; then
            echo "[Warning]: $libClangName was already installed"
            return
        fi
    done

    cat << "_EOF"
------------------------------------------------------
PREPARE TO INSTALL CLANG 5
------------------------------------------------------
_EOF
    # clang version, change it if you need other version
    # clangVersion=5.0.1
    clangInstDir=$commInstdir/clang-$clangVersion
    $execPrefix mkdir -p $clangInstDir
    cat << "_EOF"
------------------------------------------------------
DOWNLOADING LLVM 5
------------------------------------------------------
_EOF
    # comm attribute to get source 'llvm'
    # this link is the same for all four packages
    wgetLink=http://releases.llvm.org/$clangVersion
    llvmTarName=llvm-$clangVersion.src.tar.xz
    llvmUntarName=llvm-$clangVersion.src

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $llvmTarName ]]; then
        echo [Warning]: Tar Ball $llvmTarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${llvmTarName}" \
             -O $llvmTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if dir already exist
    if [[ -d $llvmUntarName ]]; then
        echo [Warning]: untarName $llvmUntarName already exist
    else
        tar -xv -f $llvmTarName
    fi
    cat << "_EOF"
------------------------------------------------------
DOWNLOADING CFE 5
------------------------------------------------------
_EOF
    # comm attribute to get source 'cfe'
    # cfeWgetLink=http://releases.llvm.org/$clangVersion
    cfeTarName=cfe-$clangVersion.src.tar.xz
    # cfeUntarName=cfe-$clangVersion.src
    cfeUntarName=$llvmUntarName/tools/clang

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $cfeTarName ]]; then
        echo [Warning]: Tar Ball $cfeTarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${cfeTarName}" \
             -O $cfeTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if dir already exist
    if [[ -d $cfeUntarName ]]; then
        echo [Warning]: untarName $cfeUntarName already exist
    else
        mkdir -p $cfeUntarName
        tar -xv -f $cfeTarName --strip-components=1 -C $cfeUntarName
    fi
    cat << "_EOF"
------------------------------------------------------
DOWNLOADING COMPILER-RT 5
------------------------------------------------------
_EOF
    # comm attribute to get source 'compiler-rt'
    # crtWgetLink=http://releases.llvm.org/$clangVersion
    crtTarName=compiler-rt-$clangVersion.src.tar.xz
    # crtUntarName=compiler-rt-$clangVersion.src
    crtUntarName=$llvmUntarName/projects/compiler-rt

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $crtTarName ]]; then
        echo [Warning]: Tar Ball $crtTarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${crtTarName}" \
             -O $crtTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if dir already exist
    if [[ -d $crtUntarName ]]; then
        echo [Warning]: untarName $crtUntarName already exist
    else
        mkdir -p $crtUntarName
        tar -xv -f $crtTarName --strip-components=1 -C $crtUntarName
    fi
    cat << "_EOF"
------------------------------------------------------
DOWNLOADING CLANG-TOOLS-EXTRA 5
------------------------------------------------------
_EOF
# CMake Error at tools/clang/tools/extra/cmake/Modules/AddCompilerRT.cmake:58 (add_library):
# add_library cannot create target "RTXray.x86_64" because another target
# with the same name already exists.  The existing target is created in
# source directory
# "~/myGit/mylx-vundle/sample/llvm-5.0.1.src/projects/compiler-rt/lib/xray".
# See documentation for policy CMP0002 for more details.
# Call Stack (most recent call first):
# tools/clang/tools/extra/lib/xray/CMakeLists.txt:66 (add_compiler_rt_object_libraries)

    # comm attribute to get source 'clang-tools-extra'
    # cteWgetLink=http://releases.llvm.org/$clangVersion
    cteTarName=clang-tools-extra-$clangVersion.src.tar.xz
    # cteUntarName=clang-tools-extra-$clangVersion.src
    cteUntarName=$llvmUntarName/tools/clang/tools/extra

    # rename download package if needed
    cd $downloadPath
    # check if already has this tar ball.
    if [[ -f $cteTarName ]]; then
        echo [Warning]: Tar Ball $cteTarName already exists
    else
        wget --no-cookies \
             --no-check-certificate \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "${wgetLink}/${cteTarName}" \
             -O $cteTarName
        # check if wget returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: wget returns error, quitting now
            exit
        fi
    fi
    # check if dir already exist
       # if [[ -d $cteUntarName ]]; then
           # echo [Warning]: untarName $cteUntarName already exist
       # else
           # mkdir -p $cteUntarName
           # tar -xv -f $crtTarName --strip-components=1 -C $cteUntarName
       # fi
    cat << "_EOF"
------------------------------------------------------
START TO COMPILE CLANG 5
------------------------------------------------------
_EOF
    cd $llvmUntarName
    buildDir=build_dir
    mkdir -p $buildDir
    cd $buildDir
    # cmakePath was set in installCmake
    # cmakePath=$commInstdir/bin/cmake
    # python3Path was set in installPython3
    python3Path=`which python3 2> /dev/null`
    # python3Path=$python3InstDir/bin/python3
    $cmakePath -G"Unix Makefiles" \
               -DCMAKE_C_COMPILER=$CC \
               -DCMAKE_CXX_COMPILER=$CXX \
               -DCMAKE_INSTALL_PREFIX=$clangInstDir \
               -DCMAKE_BUILD_TYPE=Release \
               -DLLVM_TARGETS_TO_BUILD="X86" \
               -DPYTHON_LIBRARY=$libPython3Path \
               -DPYTHON_EXECUTABLE=$python3Path \
               -DLLVM_INCLUDE_TESTS=OFF \
               $downloadPath/$llvmUntarName
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quitting now
        exit
    fi

    libClangPath=$clangInstDir/lib/libclang.so
    # clangNeedInstall=TRUE
    clangNeedInstall=FALSE
    if [[ "$clangNeedInstall" == "TRUE" ]]; then
        # install may take up 3G+ space
        $execPrefix make install
    else
        $execPrefix mkdir -p $clangInstDir/lib
        $execPrefix cp ./lib/libclang.so.5 $libClangPath
        ls -l $libClangPath
    fi

    # check if make install/cp returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make install or cp $libClangPath returns error, quitting now
        exit
    fi
    cat << _EOF
------------------------------------------------------
INSTALLING LLVM DONE
libclang.so path = $libClangPath
------ suggest (need not do)
cd $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd
mv libclang.so.5 libclang.so.5-bak
ln -s $libClangPath libclang.so.5
------------------------------------------------------
_EOF
}

# compile YouCompleteMe
installYcm() {
    ycmCoreDir="$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd"
    ycmCorePath="$ycmCoreDir/ycm_core.so"
    if [[ -f $ycmCorePath ]]; then
        echo 'Warning: already has YouCompleteMe installed'
        return 0
    fi
    cat << "_EOF"
------------------------------------------------------
COMPILING YOUCOMPLETEME
------------------------------------------------------
_EOF
    # comm attribute for getting source ycm
    repoLink=https://github.com/Valloric
    repoName=YouCompleteMe
    ycmInstDir=$HOME/.vim/bundle/YouCompleteMe
    if [[ -d $ycmInstDir ]]; then
        echo [Warning]: already has YCM repo cloned
    else
        git clone $repoLink/$repoName $ycmInstDir
        # check if clone returns successfully
        if [[ $? != 0 ]]; then
            echo [Error]: git clone returns error, quitting now
            exit
        fi
    fi

    cd $ycmInstDir
    git submodule update --init --recursive
    if [[ $platOsType == 'macos' || $platOsType == 'ubuntu' ]]; then
        python3 ./install.py --clang-completer --system-libclang
        if [[ $? != 0 ]]; then
            echo "install YCM returns error, quitting now "
            exit 1
        fi
        return 0
    fi

    # not use official install script, self compile it
    # $python3Path ./install.py --clang-completer
    ycmBuildDir=ycm_build
    mkdir -p $ycmBuildDir
    cd $ycmBuildDir
    # remove old CMakeCache.txt
    rm -rf CMakeCache.txt

    # -DUSE_PYTHON2=OFF, do not use python2 library
    # -- Found PythonLibs: ~/.usr/lib/libpython3.6m.so
    # (found suitable version "3.6.4", minimum required is "3.3")
    $cmakePath -G "Unix Makefiles" \
               -DCMAKE_C_COMPILER=$CC \
               -DCMAKE_CXX_COMPILER=$CXX \
               -DEXTERNAL_LIBCLANG_PATH=$libClangPath \
               -DCMAKE_BUILD_TYPE=Release \
               -DPYTHON_EXECUTABLE=$python3Path \
               -DPYTHON_LIBRARY=$libPython3Path \
               -DUSE_PYTHON2=OFF \
               $ycmInstDir/third_party/ycmd/cpp
    # check if install returns successfully
    if [[ $? != 0 ]]; then
        echo "cmake -G "Unix Makefiles" error, quitting now "
        exit
    fi
    cat << "_EOF"
------------------------------------------------------
BUILDING YCM_CORE NOW
------------------------------------------------------
_EOF
    # $cmakePath --build . --target ycm_core
    make -j $cpuCoreNum
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo "[Error]: make ycm_core error, quitting now "
        exit
    fi

    cat << _EOF
------------------------------------------------------
CHECK IF ANY DYNAMIC LIBRARY LINK ISSUE
------------------------------------------------------
_EOF
    # ycmCoreDir="$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd"
    # ycmCorePath="$ycmCoreDir/ycm_core.so"
    lddPath=`which ldd 2> /dev/null`
    if [[ $lddPath != "" ]]; then
        # loop to check and fix issue
        loopCnt=2
        for (( i = 0; i < $loopCnt; i++ )); do
            isSomeNotFound=`$lddPath $ycmCorePath | grep -i 'not found'`
            if [[ "$isSomeNotFound" != "" ]]; then
                cat << _EOF
------------------------------------------------------ LINK BAD
_EOF
                $lddPath $ycmCorePath
                # try to fix issue libclang.so.5 not found
                cat << _EOF
------------------------------------------------------ TRY FIX
_EOF
                cd $ycmCoreDir
                linkedName=libclang.so.5
                ln -sf $libClangPath $linkedName
                ls -l $linkedName
            else
                cat << _EOF
------------------------------------------------------ LINK WELL
_EOF
                $lddPath $ycmCorePath
                break
            fi
        done
    fi
}

preInstallForLinux() {
    cat << "_EOF"
------------------------------------------------------
PRE INSTALL FOR LINUX PLATFORM - WITH SUDO
------------------------------------------------------
_EOF
    # only run this for the first time
    if [[ ! -f $mainWd/$mRunFlagFile ]]; then
        if [[ $platOsType == "ubuntu" && $execPrefix == "sudo" ]]; then
            sudo apt-get install \
                pkg-config libevent-dev libncurses5 libncurses5-dev \
                bash-completion python-optcomplete build-essential cmake \
                automake asciidoc xmlto tmux curl cargo realpath \
                libpcre3-dev liblzma-dev libclang-5.0-dev clang-5.0 \
                libmpc-dev libcurl4-openssl-dev perl libperl-dev \
                libncursesw5 libncursesw5-dev libgnome2-dev libgnomeui-dev \
                libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                libcairo2-dev libx11-dev libxpm-dev libxt-dev \
                python-dev python3-dev ruby-dev lua5.1 lua5.1-dev -y

        elif [[ $platOsType = 'centos' && $execPrefix == 'sudo' ]]; then
            sudo yum install \
                xz-devel libX11-devel libXpm-devel libXt-devel libevent-devel \
                pcre-devel mlocate bash-completion python-optcomplete \
                cmake ncurses* gmp-devel gcc gcc-c++ automake asciidoc \
                xmlto perl-devel tmux git \
                ruby ruby-devel lua lua-devel luajit \
                luajit-devel python python-devel \
                python3 python3-devel python34 python34-devel tcl-devel \
                curl libcurl-devel perl perl-devel perl-ExtUtils-ParseXS \
                perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
                perl-ExtUtils-Embed -y
        fi
        cat << "_EOF"
------------------------------------------------------
CREATING MORE TIMES RUNNING FLAG FILE
------------------------------------------------------
_EOF
        touch $mainWd/$mRunFlagFile
    else
        cat << _EOF
------------------------------------------------------
[WARNING]: YOU MAY NEED DELETE ./$mRunFlagFile
------------------------------------------------------
_EOF
        return
    fi
}

preInstallForMacos() {
    whereIsBrew=`which brew 2> /dev/null`
    if [[ "$whereIsBrew" == "" ]]; then
        cat << "_EOF"
------------------------------------------------------
INSTALLING HOMEBREW INTO SYSTEM
------------------------------------------------------
_EOF
        /usr/bin/ruby -e "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/master/install)"
        if [[ $? != 0 ]]; then
            echo "install homebrew returns error, quitting now "
            exit 1
        fi
    fi

    cat << "_EOF"
------------------------------------------------------
PRE INSTALL FOR MACOS PLATFORM - WITH BREW
------------------------------------------------------
_EOF
    if [[ ! -f $mainWd/$mRunFlagFile ]]; then
        # as ordinary user run brew
        # use gnu-sed as compatible with that under Linux
        brew install python3 python2 cmake vim git fd \
            bash-completion fontconfig tmux ripgrep \
            gnu-sed the_silver_searcher --with-default-names -y
        cat << "_EOF"
------------------------------------------------------
CREATING MORE TIMES RUNNING FLAG FILE
------------------------------------------------------
_EOF
        touch $mainWd/$mRunFlagFile
    else
        cat << _EOF
------------------------------------------------------
[WARNING]: YOU MAY NEED DELETE ./$mRunFlagFile
------------------------------------------------------
_EOF
    fi
    # set path vars for use in installSummary
    CC=`which clang 2> /dev/null`
    CXX=`which clang++ 2> /dev/null`
    agPath=`which ag 2> /dev/null`
    rgPath=`which rg 2> /dev/null`
    fdPath=`which fd 2> /dev/null`
    tmuxPath=`which tmux 2> /dev/null`
    python3Path=`which python3 2> /dev/null`
    vimPath=`which vim 2> /dev/null`
    cmakePath=`which cmake 2> /dev/null`
    fzfPath=`which fzf 2> /dev/null`
}

# auto correct path of key packages according to the system
finalAdjustParams() {
    cat << _EOF
------------------------------------------------------
CORRECTING PYTHON3 INTERPRETER PATH IN $HOME/.vimrc
------------------------------------------------------
_EOF
    if [[ $python3Path == "" ]]; then
        python3Path=`which python3`
    fi
    matchStr="ycm_server_python_interpreter"
    sed -i --regexp-extended \
        "/$matchStr/c let g:$matchStr = '$python3Path'" $HOME/.vimrc
    # check return status
    retVal=$?
    if [[ $retVal != 0 ]]; then
        echo "[Warning]: replace python3 interpreter path returns $retVal "
    fi

#    cat << _EOF
#------------------------------------------------------
#CORRECTING COLOR SCHEME IN $HOME/.vimrc
#------------------------------------------------------
#_EOF
#    matchStr=':colorscheme'
#    replacedTo="mydefault"
#    # Linux use :colorscheme mydefault, macos use darkcoding
#    # all use darkcoding
#    if [[ 1 == 1 || $platOsType == "macos" ]]; then
#        replacedTo=darkcoding
#    fi
#    sed -i --regexp-extended \
#        "/$matchStr/c $matchStr $replacedTo" $HOME/.vimrc
#    # check return status
#    retVal=$?
#    if [[ $retVal != 0 ]]; then
#        echo "[Warning]: replace color scheme returns $retVal "
#    fi

    # find c++ header include directory
    sysTackleDir=/usr/include
    cppTackleDir=$sysTackleDir/c++
    if [[ -d $cppTackleDir ]]; then
        cat << _EOF
----------------------------------------------------------
CORRECTING C++ INCLUDE DIRECTORY IN $HOME/.ycm_extra_conf.py
----------------------------------------------------------
_EOF
        cppHeaderPath=`find  $cppTackleDir -maxdepth 1 -mindepth 1 -type d \
            | head -n 1 2> /dev/null`
        if [[ $cppHeaderPath != "" ]]; then
            matchStr="usr\/include\/c\+\+"
            sed -i --regexp-extended \
                "/$matchStr/c '$cppHeaderPath'," $HOME/.ycm_extra_conf.py
        fi
    fi
    # check return status
    retVal=$?
    if [[ $retVal != 0 ]]; then
        echo "[Warning]: replace c++ header directory returns $retVal "
    fi

    # only macos needed, for macos not support --color=auto
    if [[ $platOsType != "macos" ]]; then
        return
    fi
    cat << _EOF
------------------------------------------------------
DELETING --COLOR=AUTO IN $HOME/.BASHRC
------------------------------------------------------
_EOF
    # delete whole line matched
    matchStr="--color=auto"
    sed -i --regexp-extended \
        "/$matchStr/d" $HOME/.bashrc
    # check return status
    retVal=$?
    if [[ $retVal != 0 ]]; then
        echo "[Warning]: deleting --color=auto returns $retVal "
    fi

cat << "_EOF"
------------------------------------------------------
INSTALLING YOUCOMPLETEME SUCCESSFULLY DONE
------------------------------------------------------
_EOF
}

installSummary() {
    set +x
    cat << _EOF
------------------------------------------------------
INSTALLATION THROUGH ONEKEY DONE - CONGRATULATION
------------------------------------------------------
gcc   path = $CC
cxx   path = $CXX
ag    path = $agPath
rg    path = $rgPath
fd    path = $fdPath
fzf   path = $fzfPath
vim   path = $vimPath
tmux  path = $tmuxPath
cmake path = $cmakePath
u-ctags path = $uCtagsPath
python3 path = $python3Path
--------------------------------------------- YCM CORE PATH -------
$ycmCorePath
-------------------------------------------------------------------
_EOF
    if [[ $platOsType != "macos" ]]; then
        cat << _EOF
-- > ✄
$libPython3Path
$libClangPath
_EOF
        echo ------------------------------------------------------
    fi
}

preInstallCheck() {
    checkPlatOsType
    checkCpuCoreNum
}

install() {
    mkdir -p $downloadPath
    if [[ $platOsType == 'macos' ]]; then
        preInstallForMacos
    else
        # if had root privilege, sudo install needed packages
        preInstallForLinux
        # check and/or install gcc first of all
        installGcc
    fi
    installBone
      # | - installTmuxPlugins
      #   - installVimPlugins
      #       | - doExtraForFzf
      #   - installBashCompletion
      #   - installFonts
    installuCtags
    if [[ $platOsType != 'macos' ]]; then
        installRust
        installRipGrep
        installFd
        installSilverSearcher
        installPython3
        installvim
        installCmake
        installTmux
        installClang
    fi
    installYcm
    finalAdjustParams
    installSummary
}

checkPlatOsType() {
    arch=$(uname -s)
    case $arch in
        Darwin)
            # echo "Platform is MacOS"
            platOsType=macos
            ;;
        Linux)
            linuxType=`sed -n '1p' /etc/issue | tr -s " " | cut -d " " -f 1`
            if [[ $linuxType == "Ubuntu" ]]; then
                # echo "Platform is Ubuntu"
                platOsType=ubuntu
            elif [[ $linuxType == "CentOS" ]]; then
                # echo "Platform is CentOS"
                platOsType=centos
            elif [[ $linuxType == "Red" ]]; then
                # echo "Platform is Red Hat"
                platOsType=redhat
            fi
            ;;
        *)
            cat << "_EOF"
------------------------------------------------------
WE ONLY SUPPORT LINUX AND MACOS SO FAR
------------------------------------------------------
_EOF
            exit 255
            ;;
    esac
}

# check platform & os type and set proper value
preInstallCheck
    # | - checkPlatOsType
    #   - checkCpuCoreNum
case $1 in
    'home')
        set -x
        commInstdir=$homeInstDir
        execPrefix=""
        instMode=home
        install
        ;;

    'root')
        set -x
        commInstdir=$rootInstDir
        execPrefix=sudo
        instMode=root
        install
        ;;

    *)
        usage
        exit
        ;;
esac
