#!/bin/bash
# add Bt Tracker for aria2c

# daemon name, specify the exact one
dName=aria2c
if [[ `ps aux | grep -i "$dName" | grep -v grep` != "" ]]; then
    echo Found $dName Service, Kill it ...
    killall $dName
fi

wgetPath="https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt"
aria2Conf="${HOME}/.aria2/aria2.conf"

list=`wget -qO- "$wgetPath" | awk NF | sed ":a;N;s/\n/,/g;ta"`

if [ "`grep "bt-tracker" $aria2Conf`" == "" ]; then
    echo Add Tracker List
    # add after last line
    sed -i '$a bt-tracker='${list} $aria2Conf
else
    echo Update Tracker List
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $aria2Conf
fi
