#!/bin/bash
# Only for ubuntu with sudo privilege
# Life is hard, let's make code easier
mainWd=$(cd $(dirname $0); pwd)
trackedFileDir=$mainWd/track-files
downloadDir=$mainWd/Downloads
trackedFiles=(
    vimrc
    bashrc
    tmux.conf
    gitconfig
    gitignore
)

# prerequesites for ubuntu
PrerequesForUbuntu=(
    fd-find
    ripgrep
    universal-ctags
)

installForUbuntu() {
    sudo apt-get update
    echo "sudo apt-get install -y ${PrerequesForUbuntu[@]}"

    installVimPlug
    createFdLinkToFdfind
    relinkShToBash
}

createFdLinkToFdfind() {
    cat << _EOF
Create fd link to fdfind
------------------------------------------------------
_EOF
    fdLinkLocation=/usr/local/bin/fd
    if [ -L $fdLinkLocation ]; then
        echo "fd link already exists, skip"
        return
    fi

    sudo ln -s $(which fdfind) $fdLinkLocation
}

relinkShToBash() {
    cat << _EOF
------------------------------------------------------
Relink sh to bash
_EOF
    if [ -L /bin/sh ] && [ $(readlink /bin/sh) == "/bin/bash" ]; then
        echo "sh is already linked to bash, skip"
        return
    fi

    # link sh to bash
    sudo ln -sf /bin/bash /bin/sh
}

installSolarizedColorScheme() {
    cat << _EOF
------------------------------------------------------
Install Solarized Color Scheme for VIM
_EOF
    if [ -f ~/.vim/colors/solarized.vim ]; then
        echo "solarized.vim already exists, skip"
        return
    fi

    if [ ! -d ~/.vim/colors ]; then
        mkdir -p ~/.vim/colors
    fi

    solarizedSrc=$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim
    cp  $solarizedSrc $HOME/.vim/colors/
}

handleTrackedFiles() {
    cat << _EOF
------------------------------------------------------
Copy tracked files to home dir, including:
    ${trackedFiles[@]}
_EOF
    for file in ${trackedFiles[@]}; do
        cp $trackedFileDir/$file ~/.$file
    done
}

installVimPlug (){
    if [ -d ~/.vim/autoload ]; then
        vim +PlugUpdate +qall
        return
    fi

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # install vim plugins
    vim +PlugInstall +qall

    installSolarizedColorScheme
}

install () {
    installForUbuntu
    handleTrackedFiles
}

install
