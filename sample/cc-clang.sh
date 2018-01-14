#!/bin/bash
set -x
# this shell start dir, normally original path
startDir=`pwd`
# main work directory
mainWd=$startDir

# Clang install
# common install dir for home | root mode
homeInstDir=~/.usr
rootInstDir=/usr/local
# default is home mode
commInstdir=$homeInstDir
#sudo or empty
execPrefix=""      
#clang install info
clangVersion=5.0.1
clangHomeInstDir=~/.usr/clang-$clangVersion
clangRootInstDir=/opt/clang-$clangVersion
clangInstDir=$clangHomeInstDir
#how many cpus os has, used for make -j 
osCpus=1

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

#cmake > 3.0
checkGccVersion() {
    gccLocation=/usr/bin/gcc
    if [[ "$CC" != "" ]]; then
        gccLocation=$CC
    fi
    version=`$gccLocation -dumpversion`
    gccVersion=${version%.*}
    basicVersion=3.0
    echo $gccVersion
    #if gcc < 4.8, exit
    if [[ `echo "$gccVersion >= $basicVersion" | bc` -ne 1 ]]; then
        echo 
    fi
}

installCmake() {
    cat << "_EOF"
------------------------------------------------------
STEP : INSTALLING CMAKE 3.10 ...
------------------------------------------------------
_EOF
    cmakeInstDir=$commInstdir
    $execPrefix mkdir -p $commInstdir
    # comm attribute to get source 'python3'
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
    ./bootstrap --prefix=$cmakeInstDir

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
    #clangInstDir=/opt-clang-$clangVersion
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
    homeGccInstDir=~/.usr/bin
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
    cmakePath=$homeInstDir/bin/cmake
    python3Path=/usr/local
    $cmakePath -G"Unix Makefiles" \
        -DCMAKE_C_COMPILER=$gccLoc \
        -DCMAKE_CXX_COMPILER=$gppLoc \
        -DCMAKE_INSTALL_PREFIX=$clangInstDir \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DPYTHON_EXECUTABLE=/usr/local/bin/python3 \
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
    $execPrefix cp buildDir/lib/libclang.so.5 $commInstdir/lib/libclang.so
    cd $startDir
    
    cat << _EOF
------------------------------------------------------
INSTALLING LLVM DONE ...
libclang.so under $commInstdir/lib/libclang.so
------ tackle below
cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd
mv libclang.so.5 libclang.so.5-bak
ln -s $commInstdir/lib/libclang.so libclang.so.5
------------------------------------------------------
_EOF
}

install() {
	checkOsCpus
    #installCmake
    installClang
}

case $1 in
    'home')
        commInstdir=$homeInstDir
        clangInstDir=$clangHomeInstDir
        execPrefix=""
        install
    ;;

    'root')
        commInstdir=$rootInstDir
        clangInstDir=$clangRootInstDir
        execPrefix=sudo
		install
    ;;

    *)
        set +x
        usage
    ;;
esac
