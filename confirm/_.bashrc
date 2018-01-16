#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

#bash command prompt
export PS1="\u@\H:\W\$ "

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# BELOW IS MYSELF CONFIGURATION.
# SET LS COLOR
# export LS_COLORS=$LS_COLORS:'di=0;35:':'ex=0;0'
export LS_COLORS=$LS_COLORS:'ex=0;0'
# MY USEFUL HANDY ALIAS. 
alias ll='ls -lF'
#use for system alias
alias ll.='ls -alF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
#use for command alias
alias gdb='gdb -q'
alias cgdb='cgdb -q'
alias netstat='netstat -tuanp'
alias cdgit='cd $HOME/myGit'
alias cdsrc='cd /usr/local/src'

# SET LOCAL USEFUL VARIABLES.
export LC_ALL=C
export SHELL=/bin/bash
export EDITOR=vim
# SET PATH VARIABLES.
PATH=$HOME/.usr/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
# export PKG_CONFIG_PATH=$HOME/.usr/lib/pkgconfig:$PKG_CONFIG_PATH
PKG_CONFIG_PATH=$HOME/.usr/lib/pkgconfig:/usr/local/lib/pkgconfig
LD_LIBRARY_PATH=$HOME/.usr/lib:$HOME/.usr/lib64:/usr/local/lib:/usr/local/lib64
export PATH
export PKG_CONFIG_PATH
export LD_LIBRARY_PATH

# SET HTTP/HTTPS PROXY.
# ssh -vv -ND 8080 [proxy_ip] [port]
#export https_proxy=socks5://127.0.0.1:8080
#export http_proxy=socks5://127.0.0.1:8080

#loop to source bash completion for tmux/git
myCompleteDir=$HOME/.completion.d
if [[ -d "$myCompleteDir" ]]; then
    for file in `find $myCompleteDir -type f`
    do
        source $file
    done
fi

# TEST IF COMMAND 'TMUX' EXIST.
if [[ "`which tmux`" != "" ]]; then
    if [[ "$TMUX" == "" ]]; then
        cat << "_EOF"
 _____   __  __   _   _  __  __
|_   _| |  \/  | | | | | \ \/ /
  | |   | |\/| | | | | |  \  /
  | |   | |  | | | |_| |  /  \
  |_|   |_|  |_|  \___/  /_/\_\

_EOF
        tmuxSession=`tmux ls`
        firstSession=`echo ${tmuxSession%%:*}`
        echo "tmux attach -t $firstSession"
    fi
else 
    echo "tmux does not exist."
fi
