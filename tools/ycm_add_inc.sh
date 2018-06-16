#!/bin/bash

incDir=inc
if [[ -d "$incDir" ]]; then
    echo "Already has directory inc, please check it"
    exit
fi

set -x

# nginx exclude dir
ngxExDir=win32
mkdir -p $incDir
cd $incDir
find .. -regex '.*.h$' ! -path '*inc*' ! -path '*win32*' -exec ln -s {} \;
