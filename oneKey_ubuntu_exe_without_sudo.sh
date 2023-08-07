#!/bin/bash
# Only for ubuntu with sudo privilege
# Life is hard, let's make code easier
mainWd=$(cd $(dirname $0); pwd)
trackedFilesDir=$mainWd/track-files
completionDirSRC=$mainWd/completion-files
completionDirDst=$HOME/.bash_completion.d
downloadDir=$mainWd/Downloads
trackedFiles=(
    vimrc
    bashrc
    tmux.conf
    gitconfig
    gitignore
)

# prerequesites for ubuntu
prerequesitesForUbuntu=(
    # Level 1
    fzf
    fd-find
    ripgrep
    universal-ctags
    tmux
    sshfs
    # Level 2
    net-tools
    libvirt-clients
    bash-completion
    build-essential
    openssh-server
)

installPrequesitesForUbuntu() {
    cat << _EOF
------------------------------------------------------
Install prerequesites for ubuntu
_EOF
    sudo apt-get update
    sudo apt-get install -y ${prerequesitesForUbuntu[@]}

    installLatestFzf
}

installForUbuntu() {
    installPrequesitesForUbuntu
    installVimPlug
    createFdLinkToFdfind
    relinkShToBash
}

installLatestFzf() {
    cat << _EOF
------------------------------------------------------
Install latest fzf (>= 0.23.0)
_EOF
    if [ -f $(which fzf) ]; then
        fzfVersion=$(fzf --version | awk '{print $1}')
        version=${fzfVersion%.*}
        if [ $(echo "$version >= 0.23" | bc) -eq 1 ]; then
            echo "fzf version is greater than 0.23.0, skip"
            return
        fi
    fi
    # remove fzf installed by apt-get, which is too old
    sudo apt-get remove -y fzf
    if [ -f $HOME/.fzf/bin/fzf ]; then
        echo "Manual installed fzf already exists, skip"
        return
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    ~/.fzf/install
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
    if [ ! -f $solarizedSrc ]; then
        echo "solarized.vim not found, skip"
        exit
    fi
    cp  $solarizedSrc $HOME/.vim/colors/
}

installVimPlug (){
    if [ -d ~/.vim/autoload ]; then
        vim +PlugUpdate +qall
        installSolarizedColorScheme
        return
    fi

    # use the `--insecure`` option to avoid certificate check
    curl --insecure -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim -c "PlugInstall | qall"
    # vim +PlugInstall +qall
    installSolarizedColorScheme
}

installTrackedFiles() {
    cat << _EOF
------------------------------------------------------
Copy tracked files to home dir, including:
    ${trackedFiles[@]}
_EOF
    for file in ${trackedFiles[@]}; do
        cp $trackedFilesDir/$file ~/.$file
    done
}

installCompletionFiles() {
    cat << _EOF
------------------------------------------------------
Install completion files
_EOF
    if [ ! -d $completionDirDst ]; then
        mkdir -p $completionDirDst
    fi

    for file in $(ls $completionDirSRC); do
        cp $completionDirSRC/$file $completionDirDst/
    done
}

changeTMOUTToWritable() {
    cat << _EOF
------------------------------------------------------
Change TMOUT to writable
_EOF
    # TMOUT is readonly in /etc/profile, change it to writable
    # so that we can unset it in .bashrc
    sudo sed -i 's/^readonly TMOUT/# readonly TMOUT/g' /etc/profile
}

install () {
    installTrackedFiles
    installForUbuntu
    installCompletionFiles
    changeTMOUTToWritable
}

install
