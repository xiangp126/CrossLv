#!/bin/bash
mainWd=$(cd $(dirname $0); pwd)
trackedFileDir=./track-files

preInstallForUbuntu () {
    sudo apt-get update
    sudo apt-get install \
        fd-find -y
}

handleTrackedFiles () {
    cp $trackedFileDir/vimrc $HOME/.vimrc -y
    cp $trackedFileDir/bashrc $HOME/.bashrc -y
}

install () {
    preInstallForUbuntu
    handleTrackedFiles
}

install

