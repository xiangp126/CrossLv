#!/bin/bash
# Only for ubuntu with sudo privilege
# Life is hard, let's make code easier
mainWd=$(cd $(dirname $0); pwd)
trackedFileDir=./track-files
trackedFiles=(
    vimrc
    bashrc
    tmux.conf
    gitconfig
    gitignore
)
downloadDir=~/Downloads

# prerequesites for ubuntu
PrerequesForUbuntu=(
    fd-find
    ripgrep
)

InstallForUbuntu() {
    sudo apt-get update
    echo "sudo apt-get install -y ${PrerequesForUbuntu[@]}"

    fdLinkLocation=/usr/local/bin/fd
    if [ -L $fdLinkLocation ]; then
        echo "fd link already exists, skip"
        return
    fi
    cat << _EOF
------------------------------------------------------
Create fd link to fdfind
------------------------------------------------------
_EOF
    sudo ln -s $(which fdfind) $fdLinkLocation
    cat << _EOF
------------------------------------------------------
Relink sh to bash
------------------------------------------------------
_EOF
    # check if soft link sh is linked to bash, if yes, skip. if not, link it
    if [ -L /bin/sh ] && [ $(readlink /bin/sh) == "/bin/bash" ]; then
        echo "sh is already linked to bash, skip"
        return
    fi
    # link sh to bash
    sudo ln -sf /bin/bash /bin/sh
    cat << _EOF
------------------------------------------------------
Manual install and deploy colorized color scheme for vim https://github.com/altercation/vim-colors-solarized
------------------------------------------------------
_EOF
    git clone $downloadDir/https://github.com/altercation/vim-colors-solarized

    if [ -f ~/.vim/colors/solarized.vim ]; then
        echo "solarized.vim already exists, skip"
        return
    fi

    if [ ! -d ~/.vim/colors ]; then
        mkdir -p ~/.vim/colors
    fi

    cp vim-colors-solarized/colors/solarized.vim ~/.vim/colors/
}

handleTrackedFiles () {
    cat << _EOF
------------------------------------------------------
Copy tracked files to home dir, including:
    ${trackedFiles[@]}
------------------------------------------------------
_EOF
    # copy tracked files to home dir and add .prefix to them
    for file in ${trackedFiles[@]}; do
        cp $trackedFileDir/$file ~/.$file
    done
}

installVimPlug () {
    cat << _EOF
------------------------------------------------------
COPY TRACKED FILES TO HOME DIR, INCLUDING:
    ${trackedFiles[@]}
------------------------------------------------------
_EOF
    if [ -d ~/.vim/autoload ]; then
        # Update the plugins
        vim +PlugUpdate +qall
        return
    fi

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # install vim plugins
    vim +PlugInstall +qall
}

install () {
    installForUbuntu
    installVimPlug
    handleTrackedFiles
}

install
