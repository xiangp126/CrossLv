#!/bin/bash
set -x
# where is shell executed
startDir=`pwd`
# main work directory, not influenced by start dir
mainWd=$(cd $(dirname $0)/../; pwd)
# Clang install
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
#sudo or empty
execPrefix=""
#clang install
clangVersion=5.0.1
clangInstDir=$commInstdir/clang-$clangVersion
#how many cpus os has, used for make -j
osCpus=1
# store all downloaded packages here
downloadPath=$mainWd/downloads
CC=`which gcc`
CXX=`which c++`

logo() {
    cat << "_EOF"
      _
  ___| | __ _ _ __   __ _
 / __| |/ _` | '_ \ / _` |
| (__| | (_| | | | | (_| |
 \___|_|\__,_|_| |_|\__, |
                    |___/
_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- compile and install newly clang version

[SYNOPSIS]
    sh $exeName [home | root | help]

[DESCRIPTION]
    home -- install to $homeInstDir/
    root -- install to $rootInstDir/

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

checkDepends() {
    #check python3 version
    python3Path=`which python3 2> /dev/null`
    python3Config=`python3-config --configdir 2> /dev/null`
    if [[ "$python3Config" == "" ]]; then
        echo [Error]: please install python3/python3-config first ...
        exit
    fi

    #check cmake version, if >= 3.1
    cmakePath=`which cmake 2> /dev/null`
    if [[ "$cmakePath" != "" ]]; then
        #cmake version 2.8.12.2
        cmakeVersion=`cmake --version`
        #2.8.12.2
        cmakeVer=`echo ${cmakeVersion} | tr -s "" | cut -d " " -f 3`
        #2.8
        cmakeV=$(echo $cmakeVer | cut -d "." -f 1,2)
        basicCmakeV=3.1
        #if installed cmake already meets the requirement
        if [[ `echo "$cmakeV >= $basicCmakeV" | bc` -ne 1 ]]; then
            echo "[Error]: cmake version not match, pls install newly cmake first ..."
            exit
        fi
    else
        echo "[Error]: cmake version not match, pls install newly cmake first ..."
        exit
    fi
}

installClang() {
    libClangName="libclang.so"
    libClangPath=`find $commInstdir/ -name libclang.so | head -n 1 2> /dev/null`
    if [[ "$libClangPath" != "" ]]; then
        echo "[Warning]: $libClangName was already installed, omitting this step ..."
        return
    fi
    cat << "_EOF"
------------------------------------------------------
STEP : PREPARE TO INSTALL CLANG 5 ...
------------------------------------------------------
_EOF
    #clang version, change it if you need other version
    #clangVersion=5.0.1
    clangInstDir=$commInstdir/clang-$clangVersion
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
    cd $downloadPath
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
    #check if dir already exist
    if [[ -d $llvmUntarName ]]; then
        echo [Warning]: $llvmUntarName already exist, Omitting untar ...
    else
        tar -xv -f $llvmTarName
    fi
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
    cd $downloadPath
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
    #check if dir already exist
    if [[ -d $cfeUntarName ]]; then
        echo [Warning]: $cfeUntarName already exist, Omitting untar ...
    else
        mkdir -p $cfeUntarName
        tar -xv -f $cfeTarName --strip-components=1 -C $cfeUntarName
    fi
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
    cd $downloadPath
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
    #check if dir already exist
    if [[ -d $crtUntarName ]]; then
        echo [Warning]: $crtUntarName already exist, Omitting untar ...
    else
        mkdir -p $crtUntarName
        tar -xv -f $crtTarName --strip-components=1 -C $crtUntarName
    fi
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
    cd $downloadPath
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
    #check if dir already exist
#    if [[ -d $cteUntarName ]]; then
#        echo [Warning]: $cteUntarName already exist, Omitting untar ...
#    else
#        mkdir -p $cteUntarName
#        tar -xv -f $crtTarName --strip-components=1 -C $cteUntarName
#    fi
    cat << "_EOF"
------------------------------------------------------
STEP : START TO COMPILE CLANG 5 ...
------------------------------------------------------
_EOF
    cd $llvmUntarName
    buildDir=build_dir
    mkdir -p $buildDir
    cd $buildDir
    #cmakePath was set in installCmake
    #cmakePath=$commInstdir/bin/cmake
    #python3Path was set in installPython3
    python3Path=`which python3 2> /dev/null`
    #python3Path=$python3InstDir/bin/python3
    $cmakePath -G"Unix Makefiles" \
               -DCMAKE_C_COMPILER=$CC \
               -DCMAKE_CXX_COMPILER=$CXX \
               -DCMAKE_INSTALL_PREFIX=$clangInstDir \
               -DCMAKE_BUILD_TYPE=Release \
               -DLLVM_TARGETS_TO_BUILD="X86" \
               -DPYTHON_LIBRARY=$python3InstDir/lib/libpython3.6m.so \
               -DPYTHON_EXECUTABLE=$python3Path \
               -DLLVM_INCLUDE_TESTS=OFF \
               $downloadPath/$llvmUntarName
    make -j $osCpus
    # check if make returns successfully
    if [[ $? != 0 ]]; then
        echo [Error]: make returns error, quiting now ...
        exit
    fi
    libClangPath=$clangInstDir/lib/libclang.so
    #clangNeedInstall=TRUE
    clangNeedInstall=FALSE
    if [[ "$clangNeedInstall" == "TRUE" ]]; then
        #normally need not install, it may take up 3G+ space
        $execPrefix make install
        # check if 'make install' successfully
        if [[ $? != 0 ]]; then
            echo [Error]: make install returns error, quiting now ...
            exit
        fi
    else
        $execPrefix mkdir -p $libClangPath/lib
        $execPrefix cp ./lib/libclang.so.5 $libClangPath
        ls -l $libClangPath
    fi

    cat << _EOF
------------------------------------------------------
INSTALLING LLVM DONE ...
libclang.so path = $libClangPath
------ suggest (need not do)
cd $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd
mv libclang.so.5 libclang.so.5-bak
ln -s $libClangPath libclang.so.5
------------------------------------------------------
_EOF
}

install() {
    mkdir -p $downloadPath
    checkOsCpus
    checkDepends
    installClang
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
        set +x
        usage
        ;;
esac
