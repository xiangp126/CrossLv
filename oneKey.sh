#!/bin/bash
# Misc Info
scriptName=$(basename $0)
workingDir=$(cd $(dirname $0); pwd)
trackedFilesDir=$workingDir/track-files
templateFilesDir=$workingDir/template
vimColorsDir=$workingDir/vim-colors
ftntToolsDir=$workingDir/ftnt-tools
completionDirSRC=$workingDir/completion-files
completionDirDst=$HOME/.bash_completion.d
downloadDir=$workingDir/Downloads
catBanner="---------------------------------------------------"
catBanner=$(echo "$catBanner" | sed 's/------/------ /g')
beautifyGap1="-> "
beautifyGap2="   "
beautifyGap3="♣  "
# ubuntu is the default OS type
osType=ubuntu
osCategory=debian
# Flags
usageFlag=false
forceUpdateFlag=false
installFlag=false
linkFlag=true
checkSudoFlag=false
toolsFlag=false

usage() {
    cat << _EOF
Usage: ./$scriptName [iuchH]
Options:
    -h, --help                      Print this help message
    -i, --install                   Create symbolic links
    -H, --hard-install              Perform a hard installation
        -t, --tools                 Link tools into $HOME/.usr/bin
        -c, --check                 Check sudo privileges
        -u, --update                Force an update

Recommdned:
    ./$scriptName -i

Examples:
    ./$scriptName -i
    ./$scriptName -it
    ./$scriptName -ic
    ./$scriptName -iu
    ./$scriptName -iuH
    ./$scriptName -h

_EOF
}

[ $# -eq 0 ] && usage
# If '-i' need an argument, like '-i hard' then you should use 'i:' with getopts
# Exp: while 'getopts "fhi:" opt; do' Notice the colon on the right side of i
while getopts "uhicHt" opt; do
    # opt is the option, like 'i' or 'h'
    case $opt in
        u)
            forceUpdateFlag=true
            installFlag=true
            ;;
        h)
            usage
            exit
            ;;
        i)
            installFlag=true
            ;;
        t)
            installFlag=true
            toolsFlag=true
            ;;
        c)
            checkSudoFlag=true
            ;;
        H)  # Hard install
            linkFlag=false
            ;;
        ?)
            echo "$userNotation Invalid option: -$OPTARG" >&2
            ;;
    esac
done

# Shift to process non-option arguments. New $1, $2, ..., $@
shift $((OPTIND - 1))
if [ $# -gt 0 ]; then
    echo "$userNotation Illegal non-option arguments: $@"
    exit 1
fi

installPrerequisitesForDebian() {
    prerequisitesForUbuntu=(
        ## Basic tools
        tmux
        rsync
        fd-find
        ripgrep
        universal-ctags
        openssl
        libssl-dev
        gdb
        bat
        curl
        libcurl4
        libcurl4-openssl-dev
        dos2unix
        expect
        sshfs
        shellcheck
        mlocate
        net-tools
        bash-completion
        openssh-server
        python3-dev
        ## build essentials
        build-essential
        libvirt-clients
        texinfo
        libisl-dev
        libgmp-dev
        libncurses-dev
        source-highlight
        libsource-highlight-dev
        libmpfr-dev
        libtool
        autoconf
        gettext
        autopoint
        ## llvm & clangd
        bear
        libear
        ## TigerVNC
        gdm3
        ubuntu-desktop
        gnome-keyring
        xfce4
        xfce4-goodies
        tigervnc-standalone-server
        tigervnc-xorg-extension
        tigervnc-viewer
        # samba
        # smbclient
        ## hyperscan
        cmake
        libboost-all-dev
        ragel
        sqlite3
        libsqlite3-dev
        libpcap-dev
    )
    cat << _EOF
$catBanner
Installing prerequisites for Ubuntu
_EOF

    sudo apt-get update
    sudo apt-get install -y "${prerequisitesForUbuntu[@]}"
    sudo updatedb
}

checkOSType() {
cat << _EOF
$catBanner
Check OS platform
_EOF
    if [[ -f /etc/os-release ]]; then
        local os_name
        os_name=$(awk -F= '/^ID=/{print $2}' /etc/os-release)

        case "$os_name" in
            "ubuntu")
                osType=ubuntu
                osCategory=debian
                echo "$beautifyGap1 The current OS type is Ubuntu."
                ;;
            "centos")
                osType=centos
                osCategory=redhat
                echo "$beautifyGap1 The current OS type is CentOS."
                echo "$beautifyGap1 We currently do not support CentOS."
                exit
                ;;
            "raspbian")
                osType=raspbian
                osCategory=debian
                echo "$beautifyGap1 The current OS type is raspbian."
                ;;
            *)
                echo "$beautifyGap1 We currently do not support this OS type."
                exit
                ;;
        esac
    elif [[ $(uname) == "Darwin" ]]; then
        osType=mac
        osCategory=mac
        echo "The current OS type is macOS (Mac)."
    else
        echo "The OS type is not supported or could not be determined."
        echo "We currently do not support this OS type."
        exit
    fi
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
Install fzf - The fuzzy finder
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

linkBatToBatcat() {
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
    ln -sf $(which batcat) $batLinkedPath
}

linkFdToFdfind() {
    cat << _EOF
$catBanner
Relink fd to fdfind
_EOF
    if [ ! -x "$(command -v fdfind)" ]; then
        echo "$beautifyGap1 fdfind is not installed, skip"
        return
    fi

    fdLinkLocation=$HOME/.usr/bin/fd
    if [ -L $fdLinkLocation ] && [ $(readlink $fdLinkLocation) == $(which fdfind) ]; then
        echo "$beautifyGap1 fd link already exists, skip"
        return
    fi

    ln -sf $(which fdfind) $fdLinkLocation
}

linkShToBash() {
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
Install Solarized Color Scheme for VIM
_EOF
    if [ -f ~/.vim/colors/solarized.vim ]; then
        echo "$beautifyGap1 solarized.vim already exists, skip"
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

followUpTrackExceptions() {
    cat << _EOF
$catBanner
Follow up the exceptions
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

    # backup the existing files to $HOME/Public/.env.bak
    local backupDir=$HOME/Public/.env.bak
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

linkVimColors() {
    cat << _EOF
$catBanner
Link vim colors to $HOME/.vim/colors
_EOF
    ls "$vimColorsDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    local targetDir=$HOME/.vim/colors
    if [ ! -d $targetDir ]; then
        mkdir -p $targetDir
    fi

    for file in $(ls $vimColorsDir); do
        if [ -L $targetDir/$file ] && [ $(readlink $targetDir/$file) == $vimColorsDir/$file ]; then
            echo "$beautifyGap1 $targetDir/$file already exists, skip"
            continue
        fi
        ln -sf $vimColorsDir/$file $targetDir/$file
    done

    # remove broken links in $targetDir
    find "$targetDir" -type l \
    -exec test ! -e {} \; \
    -exec echo "$beautifyGap3 Deleting broken link: {}" \; \
    -exec rm -f {} \;
}

installVimColors() {
    cat << _EOF
$catBanner
Install vim colors to $HOME/.vim/colors
_EOF
    ls "$vimColorsDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    local targetDir=$HOME/.vim/colors
    if [ ! -d $targetDir ]; then
        mkdir -p $targetDir
    fi

    for file in $(ls $vimColorsDir); do
        if [ -f $targetDir/$file ]; then
            echo "$beautifyGap1 $targetDir/$file already exists, skip"
            continue
        fi
        rsync -av $vimColorsDir/$file $targetDir/$file
    done
}

linkFtntTools() {
    cat << _EOF
$catBanner
Link ftnt tools to $HOME/.usr/bin
_EOF
    ls "$ftntToolsDir" | while read -r file; do
        echo "$beautifyGap2 $file"
    done
    echo

    local targetDir=$HOME/.usr/bin
    if [ ! -d $targetDir ]; then
        mkdir -p $targetDir
    fi

    for file in $(ls $ftntToolsDir); do
        if [ -L $targetDir/$file ] && [ $(readlink $targetDir/$file) == $ftntToolsDir/$file ]; then
            echo "$beautifyGap1 $targetDir/$file already exists, skip"
            continue
        fi
        ln -sf $ftntToolsDir/$file $targetDir/$file
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

    if grep -q "^readonly TMOUT" /etc/profile; then
        echo "$beautifyGap1 TMOUT is readonly in /etc/profile, change it to writable"
    else
        echo "$beautifyGap1 TMOUT is already writable in /etc/profile, skip"
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

mainInstallProcedure() {
    if [ "$osCategory" == "debian" ]; then
        echo "$beautifyGap1 Processing $osType ..."
        # Pre-Installation
        [ "$checkSudoFlag" == "true" ] && checkSudoPrivilege
        [ "$forceUpdateFlag" == "true" ] && installPrerequisitesForDebian
        # In-Installation
        if [ "$linkFlag" == "true" ]; then
            linkTrackedFiles
        else
            installTrackedFiles
        fi
        linkCompletionFiles
        linkVimColors
        [ "$toolsFlag" == "true" ] && linkFtntTools
        [ "$toolsFlag" == "true" ] && linkTemplateFiles
        followUpTrackExceptions
        # Vim plugins & fzf
        installVimPlugs
        installLatestFzf # This should be after installVimPlugs
        # Post-Installation, currentlu only enabled for ubuntu
        linkShToBash
        linkBatToBatcat
        linkFdToFdfind
        setTimeZone
        changeTMOUTToWritable
    elif [ "$osCategory" == "mac" ]; then
        echo "$beautifyGap1 Processing $osType ..."
        # Pre-Installation, currently disabled for MacOS
        # [ "$checkSudoFlag" == "true" ] && checkSudoPrivilege
        # [ "$forceUpdateFlag" == "true" ] && installPrequesitesForMac

        # In-Installation
        if [ "$linkFlag" == "true" ]; then
            linkTrackedFiles
        else
            installTrackedFiles
        fi
        installVimPlugs
        installLatestFzf # This should be after installVimPlugs
        linkCompletionFiles
    fi
}

main() {
    checkOSType
    mainInstallProcedure
    printMessage
}


[ "$installFlag" == "true" ] && main
