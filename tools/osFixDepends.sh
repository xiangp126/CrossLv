#!/bin/bash
# only works for Ubuntu by 15 Dec, 2017.

#dependency for Ubuntu
ubuntuDepends=(
    "bash-completion"
    "python-optcomplete"
    #build tools
    "build-essential"
    "cmake"
    "cmake3"
    "ctags"
    "python-dev"
    "python3-dev"
    "libmpc-dev"  #for compile gcc
    #for compile git
    "libcurl4-openssl-dev"
    "automake"
    "asciidoc"
    "xmlto"
    "libperl-dev"
    #for compile vim8
    "perl"
    "lib32ncursesw5-dev"
    #common tools
    "figlet"            
    "shellcheck"
    "htop"
    "iftop"
    "tcpdump"
    "netcat"        # also known as nc
    "bridge-utils"
    "tmux"          # terminal multiplexer
    "checkinstall"
    "mosh"          # mobile ssh tool
    "realpath"
)

#dependency for CentOS
centosDepends=(
    "bash-completion"
    "python-optcomplete"
    #compile tools
    "cmake"
    "ncurses*"
    "ctags"
    "python-devel"
    "gmp-devel"
    "gcc"
    "gcc-c++"
    #"shellcheck"
    #for git use
    "libcurl-devel"
    "automake"
    "asciidoc"
    "xmlto"
    "perl-devel"
    # common tools
    "figlet"            
    "mosh"          # mobile ssh tool
    "htop"
    "iftop"
    #"netcat"        # also known as nc
    "bridge-utils"
    "tmux"          # terminal multiplexer
)

logo() {
    cat << "_EOF"
     _                           _
  __| | ___ _ __   ___ _ __   __| |___
 / _` |/ _ \ '_ \ / _ \ '_ \ / _` / __|
| (_| |  __/ |_) |  __/ | | | (_| \__ \
 \__,_|\___| .__/ \___|_| |_|\__,_|___/
           |_|
_EOF
}

usage() {
    exeName=${0##*/}
    cat << _EOF
[NAME]
    $exeName -- fix common dependes for this OS
                || no sudo before command

[SYNOPSIS] 
    sh $exeName [install | uninstall | help]
_EOF
    cat << "_EOF"

[USAGE]
    $ figlet Hello
	 _          _ _
	| |__   ___| | | ___
	| '_ \ / _ \ | |/ _ \
	| | | |  __/ | | (_) |
	|_| |_|\___|_|_|\___/
	
     $ shellcheck ~/.bashrc
_EOF
}

# fix dependency for root mode
fixDepends() {
	#install or uninstall
	para=$1
    cat << "_EOF"
------------------------------------------------------
START TO FIX DEPENDENCY ...
------------------------------------------------------
_EOF
    osType=`sed -n '1p' /etc/issue | tr -s " " | cut -d " " -f 1 | \
        grep -i "[ubuntu|centos]"`
    # fix dependency all together.
    case "$osType" in
        'Ubuntu')
            echo "OS is Ubuntu..."
            for pkg in ${ubuntuDepends[@]}
            do
                sudo apt-get $para $pkg -y
            done
        ;;
        'CentOS' | 'Red')
            echo "OS is CentOS or Red Hat..."
            yum groupinstall "Development Tools" -y
            for pkg in ${centosDepends[@]}
            do
                sudo yum $para $pkg -y
            done
        ;;
        *)
            echo Not Ubuntu or CentOS
            echo not sure whether this script would work
            echo Please check it yourself ...
            exit
        ;;
    esac
}

parseInput() {
    case "$1" in
        'install')
            fixDepends install
        ;;

        'uninstall')
            fixDepends remove
        ;;

        *)
            usage
        ;;
    esac
}

# begin to parse input.
parseInput $1
