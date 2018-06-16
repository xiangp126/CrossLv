#!/bin/bash

incDir=inc
if [[ -d "$incDir" ]]; then
    echo "Already has directory inc, please check it"
    exit
fi

set -x

mkdir -p $incDir
cd $incDir
find .. -name '*.h' -exec ln -sf {} \;
