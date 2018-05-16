#!/bin/bash
installDir=/usr/local
wgetDir=wget https://github.com/cgdb/cgdb/archive/v0.7.0.tar.gz
srcDir=/usr/local/src
untarName=cgdb-0.7.0

cd $srcDir
wget $wgetDir -O $untarName
cd $untarName
/bin/bash autogen.sh
./configure --prefix=$installDir
make -j
make install
