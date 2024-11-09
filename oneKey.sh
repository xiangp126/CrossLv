#!/bin/bash
# set -x

# Constants
SCRIPT_NAME=$(basename $0)
USER_NOTATION="@@@@"
SEPARATOR="==================================================="
# Variables
workingDir=$(cd $(dirname $0); pwd)
trackedFilesDir=$workingDir/track-files
templateFilesDir=$workingDir/template
vimColorsDir=$workingDir/vim-colors
ftntToolsDir=$workingDir/ftnt-tools
completionDirSRC=$workingDir/completion-files
completionDirDst=$HOME/.bash_completion.d
# ubuntu is the default OS type
osCategory=debian
# Flags
fInsTools=false
fForceUpdate=false
# Colors
CYAN='\033[36m'
RED='\033[31m'
BOLD='\033[1m'
GREEN='\033[32m'
MAGENTA='\033[35m'
YELLOW='\033[33m'
LIGHTYELLOW='\033[93m'
NORMAL='\033[0m'
BLUE='\033[34m'
GREY='\033[90m'
RESET='\033[0m'
COLOR=$MAGENTA

usage() {
    cat << _EOF

Persist the environment settings and tools for the current user

Usage: ./$SCRIPT_NAME [uth]

Options:
    -t, --tools     Link tools into $HOME/.usr/bin
    -u, --update    Force an update of prerequisites
    -h, --help      Print this help message

Recommdned:
    ./$SCRIPT_NAME -t

Examples:
    ./$SCRIPT_NAME
    ./$SCRIPT_NAME -t
    ./$SCRIPT_NAME -u
    ./$SCRIPT_NAME -h

_EOF
exit 0
}

while getopts "uht" opt; do
    # opt is the option, like 'i' or 'h'
    case $opt in
        t)
            fInsTools=true
            ;;
        u)
            fForceUpdate=true
            ;;
        h)
            usage
            ;;
        ?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Shift to process non-option arguments. New $1, $2, ..., $@
shift $((OPTIND - 1))
if [ $# -gt 0 ]; then
    echo "Illegal non-option arguments: $@"
    exit 1
fi

installPrerequisitesForDebian() {
    checkSudoPrivilege
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
        remmina # remote desktop client
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

    echo -e "${COLOR}Installing prerequisites for Ubuntu${RESET}"

    sudo apt-get update
    sudo apt-get install -y "${prerequisitesForUbuntu[@]}"
    sudo updatedb
}

checkOSPlat() {
    echo -e "${COLOR}Checking OS platform${RESET}"
    if [[ -f /etc/os-release ]]; then
        local os_name
        os_name=$(awk -F= '/^ID=/{print $2}' /etc/os-release)

        case "$os_name" in
            "ubuntu")
                osCategory=debian
                echo "The current OS type is Ubuntu."
                ;;
            "centos")
                osCategory=redhat
                echo "The current OS type is CentOS."
                echo "We currently do not support CentOS."
                exit
                ;;
            "raspbian")
                osCategory=debian
                echo "The current OS type is raspbian."
                ;;
            *)
                echo "We currently do not support this OS type."
                exit
                ;;
        esac
    elif [[ $(uname) == "Darwin" ]]; then
        osCategory=mac
        echo "The current OS type is macOS (Mac)."
    else
        echo "The OS type is not supported or could not be determined."
        echo "We currently do not support this OS type."
        exit
    fi
}

installPrequesitesForMac() {
    checkSudoPrivilege
    prerequisitesForMac=(
       yt-dlp
       fzf
       fd
       bat
       vim
    )

    echo -e "${COLOR}Installing prerequisites for macOS${RESET}"
    brew update
    brew install "${prerequisitesForMac[@]}"
}

setTimeZone() {
    echo -e "${COLOR}Setting timezone to Vancouver${RESET}"
    # check time zone if it is already vancouver
    if [ $(timedatectl | grep "Time zone" | awk '{print $3}') == "America/Vancouver" ]; then
        echo -e "${GREY}Time zone is already vancouver${RESET}"
        return
    fi
    sudo timedatectl set-timezone America/Vancouver
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success!${RESET}"
    else
        echo -e "${RED}Failed!${RESET}"
        exit 1
    fi
}

installLatestFzf() {
    echo -e "${COLOR}Installing fzf - The fuzzy finder${RESET}"
    if [ -x "$(command -v fzf)" ]; then
        fzfVersion=$(fzf --version | awk '{print $1}')
        version=${fzfVersion%.*}
        if [ $(echo "$version >= 0.23" | bc) -eq 1 ]; then
            echo "fzf version is greater than 0.23.0, skip"
            return
        fi
        sudo apt-get remove -y fzf
    fi

    # Check if fzf was already installed by vim-plug in ~/.vim/bundle/fzf
    fzfBinFromVimPlug=$HOME/.vim/bundle/fzf/bin/fzf
    if [ -f $fzfBinFromVimPlug ]; then
        if [ -L /usr/local/bin/fzf ] && [ $(readlink /usr/local/bin/fzf) == $fzfBinFromVimPlug ]; then
            echo "fzf is already linked to $fzfBinFromVimPlug, skip"
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


relinkCommand() {
    local linkName=$1
    local sysCmd=$2
    local linkDst=$HOME/.usr/bin
    [ -n "$3" ] && linkDst=$3
    local dst=$linkDst/$linkName

    echo -e "${COLOR}Relink ${linkName} to ${sysCmd}${RESET}"
    [ ! -d "$linkDst" ] && mkdir -p "$linkDst"

    sysCmdPath=$(command -v "$sysCmd")
    if [ -z "$sysCmdPath" ]; then
        echo "${sysCmd} is not installed"
        return
    fi

    if [ -L "$dst" ] && [ "$(readlink "$dst")" == "$sysCmdPath" ]; then
        echo -e "${GREY}${linkName} is already linked to ${sysCmd}${RESET}"
        return
    fi

    # Create the symlink
    ln -sf "$sysCmdPath" "$dst"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success!${RESET}"
    else
        echo -e "${RED}Failed!${RESET}"
        exit 1
    fi
}

installVimPlugsManager (){
    echo -e "${COLOR}Install Vim Plugs Manager${RESET}"
    local vimPlugLoc=$HOME/.vim/autoload/plug.vim

    if [ ! -f ~/.vimrc ]; then
        echo "No .vimrc found, Abort!"
        exit 1
    fi

    if [ ! -f "$vimPlugLoc" ]; then
        # use the --insecure option to avoid certificate check
        curl --insecure -fLo "$vimPlugLoc" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

        # Comment out the line in .vimrc starts with colorscheme
        if grep -q "colorscheme" ~/.vimrc; then
            sed -i 's/^colorscheme/\" colorscheme/g' ~/.vimrc
        fi
    else
        echo -e "${GREY}Vim Plug is already installed${RESET}"
    fi

    vim +PlugInstall +PlugUpdate +qall

    if [ ! -f "$vimPlugLoc" ]; then
        # Uncomment the line in .vimrc starts with colorscheme
        if grep -q "\" colorscheme" ~/.vimrc; then
            sed -i 's/^\" colorscheme/colorscheme/g' ~/.vimrc
        fi
    fi
}

followUpTrackExceptions() {
    echo -e "${COLOR}Follow up the exceptions${RESET}"
    # Copy back the privileged git config.
    gitconfigCheckFile=$HOME/.gitconfig.fortinet
    if [ -f "$gitconfigCheckFile"  ]; then
        echo "The privileged file $gitconfigCheckFile exists."
        echo "Relink $HOME/.gitconfig to $gitconfigCheckFile"
        ln -sf "$gitconfigCheckFile" "$HOME"/.gitconfig
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Success!${RESET}"
        else
            echo -e "${RED}Failed!${RESET}"
            exit 1
        fi
    fi
}

linkFiles() {
    local srcDir="$1"        # Source directory
    local dstDir="$2"        # Destination directory
    local copyToHidden="$3"  # Copy to hidden file
    local backupDir="$3"     # Optional backup directory
    local dstPresix=""       # Prefix for destination filename

    echo -e "${COLOR}Linking files from $(basename "$srcDir") to ${dstDir}${RESET}"
    [ ! -d "$dstDir" ] && mkdir -p "$dstDir"
    [ -n "$backupDir" ] && [ ! -d "$backupDir" ] && mkdir -p "$backupDir"
    [ -n "$copyToHidden" ] && dstPresix="."

    # Iterate over files in the source directory
    for file in "$srcDir"/*; do
        local filename=$(basename "$file")
        local src="$srcDir/$filename"
        local dst="$dstDir/${dstPresix}$filename"

        # echo -e "Linking ${COLOR}$filename${RESET} => $dst"
        echo -e "${LIGHTYELLOW}$filename${RESET}"

        # If target exists in the destination as a regular file (not a symlink), back it up first
        if [ -n "$backupDir" ] && [ -f "$dst" ] && [ ! -L "$dst" ]; then
            echo "$dst is not a link, backing it up to $backupDir"
            mv "$dst" "$backupDir/$filename.bak"
        fi

        # If the symlink already exists and points to the correct location, skip it
        if [ -L "$dst" ] && [ "$(readlink "$dst")" == "$src" ]; then
            echo -e "${GREY}$dst is already been linked.${RESET}"
            continue
        fi

        # Create or update the symbolic link
        ln -sf "$src" "$dst"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Success!${RESET}"
        else
            echo -e "${RED}Failed!${RESET}"
            exit 1
        fi
    done

    COLOR=$GREEN
    find "$dstDir" -type l ! \
            -exec test -e {} \; \
            -exec rm -f {} \; \
            -exec echo -e "${COLOR}Deleting broken link: {}${RESET}" \;
    COLOR=$MAGENTA
}

changeTMOUTToWritable() {
    echo -e "${COLOR}Change TMOUT to writable${RESET}"
    # TMOUT is readonly in /etc/profile, change it to writable
    # so that we can unset it in .bashrc
    if ! grep -q "TMOUT" /etc/profile; then
        echo "TMOUT is not found in /etc/profile, skip"
        return
    fi

    if grep -q "^readonly TMOUT" /etc/profile; then
        echo "TMOUT is readonly in /etc/profile, change it to writable"
    else
        echo -e "${GREY}TMOUT is already writable in /etc/profile${RESET}"
        return
    fi

    sudo sed -i 's/^readonly TMOUT/# readonly TMOUT/g' /etc/profile
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success!${RESET}"
    else
        echo -e "${RED}Failed!${RESET}"
        exit 1
    fi
}

checkSudoPrivilege() {
    echo -e "${COLOR}Checking sudo privilege${RESET}"
    if sudo -v >/dev/null 2>&1; then
        echo "You have sudo privilege. Continue!"
    else
        echo "You do not have sudo privilege. Abort!"
        exit 0
    fi
}

mainInstallProcedure() {
    if [ "$osCategory" == "debian" ]; then
        [ "$fForceUpdate" == "true" ] && installPrerequisitesForDebian
        linkFiles "$trackedFilesDir" "$HOME" 1 "$HOME/Public/.env.bak"
        linkFiles "$completionDirSRC" "$completionDirDst"
        linkFiles "$vimColorsDir" "$HOME/.vim/colors"

        if [ "$fInsTools" == "true" ]; then
            echo -e "${COLOR}Linking FTNT tools ...${RESET}"
            linkFiles "$ftntToolsDir" "$HOME/.usr/bin"
            echo -e "${COLOR}Linking template files ...${RESET}"
            linkFiles "$templateFilesDir" "$HOME/Templates"
        fi

        followUpTrackExceptions
        installVimPlugsManager
        # installLatestFzf # fzf is already installed by vim-plug
        relinkCommand "bat" "batcat"
        relinkCommand "fd" "fdfind"
        relinkCommand "sh" "bash" /bin/
        setTimeZone
        changeTMOUTToWritable
    elif [ "$osCategory" == "mac" ]; then
        # Pre-Installation, currently disabled for MacOS
        # [ "$forceUpdateFlag" == "true" ] && installPrequesitesForMac
        linkFiles "$trackedFilesDir" "$HOME" 1 "$HOME/Public/.env.bak"
        linkFiles "$completionDirSRC" "$completionDirDst"
        linkFiles "$vimColorsDir" "$HOME/.vim/colors"
        installVimPlugsManager
    fi
}

checkOSPlat
mainInstallProcedure
