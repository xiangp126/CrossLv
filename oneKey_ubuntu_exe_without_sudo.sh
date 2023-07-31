#!/bin/bash
mainWd=$(cd $(dirname $0); pwd)
trackedFileDir=./track-files

preInstallForUbuntu () {
    sudo apt-get update
    sudo apt-get install \
        fd-find -y
}

handleTrackedFiles () {
    # Deploy solarized
    git clone https://github.com/altercation/vim-colors-solarized
    cd vim-colors-solarized/colors
    mkdir -p ~/.vim/colors
    mv solarized.vim ~/.vim/colors/

    trackedVimrc=$trackedFileDir/vimrc
    trackedBashrc=$trackedFileDir/bashrc
    trackedGitconfig=$trackedFileDir/gitconfig
    trackedGitignore=$trackedFileDir/gitignore
    cp $trackedVimrc $HOME/.vimrc
    cp $trackedBashrc $HOME/.bashrc
    cp $trackedGitconfig $HOME/.gitconfig
    cp $trackedGitignore $HOME/.gitignore
}

install () {
    preInstallForUbuntu
    handleTrackedFiles
}

install

