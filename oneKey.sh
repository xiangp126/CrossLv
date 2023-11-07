#!/bin/bash

mainWd=$(cd $(dirname $0); pwd)
trackedFilesDir=$mainWd/track-files
templateFilesDir=$mainWd/template
handyToolsDir=$mainWd/handy
completionDirSRC=$mainWd/completion-files
completionDirDst=$HOME/.bash_completion.d
downloadDir=$mainWd/Downloads
catBanner="---------------------------------------------------"
catBanner=$(echo "$catBanner" | sed 's/------/------ /g')
beautifyGap1="-> "
beautifyGap2="   "
beautifyGap3="♣  "
# ubuntu is the default platform
platform=ubuntu

checkPlatform() {
    if [[ -f /etc/os-release ]]; then
        local os_name
        os_name=$(awk -F= '/^ID=/{print $2}' /etc/os-release)

        case "$os_name" in
            "ubuntu")
                platform=ubuntu
                echo "$beautifyGap1 The current platform is Ubuntu."
                ;;
            "centos")
                platform=centos
                echo "$beautifyGap1 The current platform is CentOS."
                echo "$beautifyGap1 We currently do not support CentOS."
                exit
                ;;
            *)
                echo "$beautifyGap1 The current platform is not Ubuntu or CentOS."
                echo "$beautifyGap1 We currently do not support this platform."
                exit
                ;;
        esac
    elif [[ $(uname) == "Darwin" ]]; then
        platform=mac
        echo "The current platform is macOS (Mac)."
    else
        echo "The platform is not supported or could not be determined."
        echo "We currently do not support this platform."
        exit
    fi
}

installPrerequisitesForUbuntu() {
    prerequisitesForUbuntu=(
        # Level 1
        tmux
        rsync
        fd-find
        ripgrep
        universal-ctags
        # Level 2
        gdb
        bat
        curl
        expect
        sshfs
        shellcheck
        dos2unix
        # Level 3
        net-tools
        texinfo
        libvirt-clients
        bash-completion
        build-essential
        openssh-server
    )

    cat << _EOF
$catBanner
Installing prerequisites for Ubuntu
_EOF

    sudo apt-get update
    sudo apt-get install -y "${prerequisitesForUbuntu[@]}"
}

relinkBatToBatcat() {
    cat << _EOF
$catBanner
Relink bat to batcat
_EOF
    # check if batcat is installed
    if [ ! -x "$(command -v batcat)" ]; then
        echo "$beautifyGap1 batcat is not installed, skip"
        return
    fi

    batLinkedPath=$HOME/.usr/bin/bat
    # check if bat is already linked to batcat
    if [ -L $batLinkedPath ] && [ $(readlink $batLinkedPath) == $(which batcat) ]; then
        echo "$beautifyGap1 bat is already linked to batcat, skip"
        return
    fi

    if [ ! -d $HOME/.usr/bin ]; then
        mkdir -p $HOME/.usr/bin
    fi
    sudo ln -sf $(which batcat) $batLinkedPath
}

setTimeZone() {
    # set timezone to vancouver, on ubuntu
    cat << _EOF
$catBanner
Set timezone to vancouver
_EOF
    # check time zone if it is already vancouver
    if [ $(timedatectl | grep "Time zone" | awk '{print $3}') == "America/Vancouver" ]; then
        echo "$beautifyGap1 Time zone is already vancouver, skip"
        return
    fi
    sudo timedatectl set-timezone America/Vancouver
}

installLatestFzf() {
    cat << _EOF
$catBanner
Install fzf - The fuzzy finder (v >= 0.23.0)
_EOF
    if [ -x "$(command -v fzf)" ]; then
        fzfVersion=$(fzf --version | awk '{print $1}')
        version=${fzfVersion%.*}
        if [ $(echo "$version >= 0.23" | bc) -eq 1 ]; then
            echo "$beautifyGap1 fzf version is greater than 0.23.0, skip"
            return
        fi
        sudo apt-get remove -y fzf
    fi

    # Check if fzf was already installed by vim-plug in ~/.vim/bundle/fzf
    fzfBinFromVimPlug=$HOME/.vim/bundle/fzf/bin/fzf
    if [ -f $fzfBinFromVimPlug ]; then
        if [ -L /usr/local/bin/fzf ] && [ $(readlink /usr/local/bin/fzf) == $fzfBinFromVimPlug ]; then
            echo "$beautifyGap1 fzf is already linked to $fzfBinFromVimPlug, skip"
            return
        fi
        sudo ln -sf $fzfBinFromVimPlug /usr/local/bin/fzf
        return
    fi

    # Then we have to install fzf manually
    if [ -f $HOME/.fzf/bin/fzf ]; then
        echo "Manual installed fzf already exists, skip"
        return
    fi

    fzfOfficialSite=https://github.com/junegunn/fzf.git
    git clone -c http.sslVerify=false --depth 1 $fzfOfficialSite $HOME/.fzf

    sed -i 's/^\([[:space:]]*curl\)/\1 -k/g' $HOME/.fzf/install
    sed -i 's/^\([[:space:]]*wget\)/\1 --no-check-certificate/g' $HOME/.fzf/install
    # ~/.fzf/install --completion --key-bindings --no-update-rc
    ~/.fzf/install --bin

    # link this fzf to /usr/local/bin/fzf
    sudo ln -sf $HOME/.fzf/bin/fzf /usr/local/bin/fzf
}

relinkFdToFdfind() {
    cat << _EOF
$catBanner
Relink fd to fdfind
_EOF
    fdLinkLocation=/usr/local/bin/fd
    if [ -L $fdLinkLocation ]; then
        echo "$beautifyGap1 fd link already exists, skip"
        return
    fi

    sudo ln -s $(which fdfind) $fdLinkLocation
}

relinkShToBash() {
    cat << _EOF
$catBanner
Relink sh to bash
_EOF
    if [ -L /bin/sh ] && [ $(readlink /bin/sh) == "/bin/bash" ]; then
        echo "$beautifyGap1 sh is already linked to bash, skip"
        return
    fi

    # link sh to bash
    sudo ln -sf /bin/bash /bin/sh
}

installSolarizedColorScheme() {
    cat << _EOF
$beautifyGap1 Install Solarized Color Scheme for VIM
_EOF
    if [ -f ~/.vim/colors/solarized.vim ]; then
        echo "$beautifyGap2 solarized.vim already exists, skip"
        return
    fi

    if [ ! -d ~/.vim/colors ]; then
        mkdir -p ~/.vim/colors
    fi

    solarizedSrc=$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim
    if [ ! -f $solarizedSrc ]; then
        echo "$beautifyGap2 solarized.vim not found, skip"
        exit
    fi
    cp  $solarizedSrc $HOME/.vim/colors/
}

installVimPlugs (){
    cat << _EOF
$catBanner
Install Vim Plugs
_EOF
    # check if .vimrc exists
    if [ ! -f ~/.vimrc ] && [ ! -L ~/.vimrc ]; then
        echo "No .vimrc found, Abort!"
        exit
    fi

    if [ -d ~/.vim/autoload ]; then
        vim +PlugInstall +PlugUpdate +qall
        installSolarizedColorScheme
        return
    fi

    # use the `--insecure`` option to avoid certificate check
    curl --insecure -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Comment out the line in .vimrc starts with colorscheme
    if grep -q "colorscheme" ~/.vimrc; then
        sed -i 's/^colorscheme/\" colorscheme/g' ~/.vimrc
    fi

    vim +PlugInstall +PlugUpdate +qall
    installSolarizedColorScheme

    # Uncomment the line in .vimrc starts with colorscheme
    if grep -q "\" colorscheme" ~/.vimrc; then
        sed -i 's/^\" colorscheme/colorscheme/g' ~/.vimrc
    fi
}

installTrackedFiles() {
    cat << _EOF
$catBanner
Sync tracked files to $HOME
_EOF
    ls "$trackedFilesDir" | while read -r file; do
      echo "$beautifyGap2 $file"
    done
    echo

    for file in $(ls $trackedFilesDir); do
        if [ -L $HOME/.$file ]; then
            rm -f $HOME/.$file
        fi
        rsync -av $trackedFilesDir/$file $HOME/.$file
    done
}

cleanUpTheExceptions() {
    cat << _EOF
$catBanner
Clean up the exceptions
_EOF
    # Copy back the privileged git config.
    gitconfigCheckFile=$HOME/.gitconfig.fortinet
    if [ -f $gitconfigCheckFile  ]; then
        echo "$beautifyGap3 The privileged file $gitconfigCheckFile exists."
        echo "$beautifyGap1 Relink $HOME/.gitconfig to $gitconfigCheckFile"
        ln -sf $gitconfigCheckFile $HOME/.gitconfig
    fi
}

linkTrackedFiles() {
    cat << _EOF
$catBanner
Link tracked files to $HOME
_EOF
    ls "$trackedFilesDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    local backupDir=$HOME/Public/env.bak
    if [ ! -d $backupDir ]; then
        mkdir -p $backupDir
    fi

    for file in $(ls $trackedFilesDir); do
        if [ -f $HOME/.$file ] && [ ! -L $HOME/.$file ]; then
            echo "$beautifyGap1 $HOME/.$file is not link, backup it to $backupDir"
            mv $HOME/.$file $backupDir/$file.bak
        fi

        if [ -L $HOME/.$file ] && [ $(readlink $HOME/.$file) == $trackedFilesDir/$file ]; then
            echo "$beautifyGap1 $HOME/.$file already exists, skip"
            continue
        fi
        ln -sf $trackedFilesDir/$file $HOME/.$file
    done
}

linkHandyTools() {
    cat << _EOF
$catBanner
Link handy tools to $HOME/.usr/bin
_EOF
    ls "$handyToolsDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    local targetDir=$HOME/.usr/bin
    if [ ! -d $targetDir ]; then
        mkdir -p $targetDir
    fi

    for file in $(ls $handyToolsDir); do
        if [ -L $targetDir/$file ] && [ $(readlink $targetDir/$file) == $handyToolsDir/$file ]; then
            echo "$beautifyGap1 $targetDir/$file already exists, skip"
            continue
        fi
        ln -sf $handyToolsDir/$file $targetDir/$file
    done

    # remove broken links in $targetDir
    find "$targetDir" -type l \
    -exec test ! -e {} \; \
    -exec echo "$beautifyGap3 Deleting broken link: {}" \; \
    -exec rm -f {} \;
}

linkTemplateFiles() {
    cat << _EOF
$catBanner
Link template files to $HOME/Template
_EOF
    ls "$templateFilesDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    targetDir=$HOME/Templates
    if [ ! -d $targetDir ]; then
        mkdir -p $targetDir
    fi

    for file in $(ls $templateFilesDir); do
        if [ -L $targetDir/$file ] && [ $(readlink $targetDir/$file) == $templateFilesDir/$file ]; then
            echo "$beautifyGap1 $targetDir/$file already exists, skip"
            continue
        fi
        ln -sf $templateFilesDir/$file $targetDir/$file
    done

    # remove broken links in $targetDir
    find "$targetDir" -type l \
    -exec test ! -e {} \; \
    -exec echo "$beautifyGap3 Deleting broken link: {}" \; \
    -exec rm -f {} \;
}

linkCompletionFiles() {
    cat << _EOF
$catBanner
Install completion files into $completionDirDst
_EOF
    ls "$completionDirSRC" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    if [ ! -d $completionDirDst ]; then
        mkdir -p $completionDirDst
    fi
    # rsync -av --delete $completionDirSRC/ $completionDirDst/
    for file in $(ls $completionDirSRC); do
        if [ -L $completionDirDst/$file ] && [ $(readlink $completionDirDst/$file) == $completionDirSRC/$file ]; then
            echo "$beautifyGap1 $completionDirDst/$file already exists, skip"
            continue
        fi
        ln -sf $completionDirSRC/$file $completionDirDst/$file
    done
}

changeTMOUTToWritable() {
    cat << _EOF
$catBanner
Change TMOUT to writable
_EOF
    # TMOUT is readonly in /etc/profile, change it to writable
    # so that we can unset it in .bashrc
    if ! grep -q "TMOUT" /etc/profile; then
        echo "$beautifyGap1 TMOUT is not found in /etc/profile, skip"
        return
    fi

    sudo sed -i 's/^readonly TMOUT/# readonly TMOUT/g' /etc/profile
    if [ $? -eq 0 ]; then
        echo "$beautifyGap1 Success!"
    else
        echo "$beautifyGap2 Failed!"
    fi
}

checkSudoPrivilege() {
    cat << _EOF
$catBanner
Check sudo privilege
_EOF
    if sudo -v >/dev/null 2>&1; then
        echo "$beautifyGap1 You have sudo privilege. Continue!"
    else
        echo "$beautifyGap2 You do not have sudo privilege. Abort!"
        exit 0
    fi
}

printMessage() {
    echo "$beautifyGap1 Please source ~/.bashrc manually to take effect."
}

help() {
    cat << _EOF
Usage: ./oneKey.sh [OPTION]

Deploy all the tools and configurations for ubuntu

OPTION:
    soft   Link tracked files to $HOME. Default Option.
    hard   Install tracked files to $HOME
    help   Print this message

_EOF
    exit 0
}

installCore() {
    if [ "$platform" == "ubuntu" ]; then
        echo "$beautifyGap1 Processing Ubuntu..."
        checkSudoPrivilege
        installPrequesitesForUbuntu
    elif [ "$platform" == "mac" ]; then
        echo "$beautifyGap1 Processing MacOS..."
        # installPrequesitesForMac
    fi

    if [ "$1" == "hard" ] || [ "$1" == "install" ]; then
        installTrackedFiles
    else
        linkTrackedFiles
    fi
    installVimPlugs
    linkCompletionFiles
    linkHandyTools
    linkTemplateFiles
    # Notice: installLatestFz after installVimPlugs
    installLatestFzf
    cleanUpTheExceptions
}

installPrequesitesForMac() {
    prerequisitesForMac=(
       yt-dlp
       fzf
       fd
       bat
       vim
    )

    cat << _EOF
$catBanner
Installing prerequisites for macOS
_EOF

    brew update
    brew install "${prerequisitesForMac[@]}"
}

install () {
    checkPlatform
    installCore $1
    if [ "$platform" == "ubuntu" ]; then
        relinkShToBash
        relinkBatToBatcat
        relinkFdToFdfind
        setTimeZone
        changeTMOUTToWritable
    fi
    printMessage
}

#!/bin/bash

case "$1" in
    "help")
        help
        ;;
    "hard"|"install")
        install "hard"
        ;;
    "soft"|"link")
        # Fall through to the default case
        :
        ;;
    *)
        install "soft"
        ;;
esac
