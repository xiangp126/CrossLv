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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# BELOW IS MYSELF CONFIGURATION.
# SET LS COLOR
# export LS_COLORS=$LS_COLORS:'di=0;35:':'ex=0;0'
export LS_COLORS=$LS_COLORS:'ex=0;0'
# MY USEFUL HANDY ALIAS. 
alias ll='ls -lF'
alias ll.='ls -alF'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias grep='grep --color=auto'
alias gdb='gdb -q'
alias cgdb='cgdb -q'
alias netstat='netstat -tuanp'
alias cdgit='cd ~/myGit'
alias cdsrc='cd /usr/local/src'

# SET LOCAL USEFUL VARIABLES.
export LC_ALL=C
export SHELL=/bin/bash
export EDITOR=vim
# SET PATH VARIABLES.
PATH=~/.usr/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
export PATH
# export PKG_CONFIG_PATH=~/.usr/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=~/.usr/lib/pkgconfig:/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=~/.usr/lib:/usr/local/lib

# SET HTTP/HTTPS PROXY.
# ssh -vv -ND 8080 [proxy_ip] [port]
# export https_proxy=socks5://127.0.0.1:8080
# export http_proxy=socks5://127.0.0.1:8080

# bash-completion for git
gitCompletionBashPath=~/.git-completion.bash
if [[ -f "$gitCompletionBashPath" ]]; then
    source $gitCompletionBashPath
fi
# bash-completion for tmux
tmuxCompletionBashPath=~/.tmux-completion.bash
if [[ -f "$tmuxCompletionBashPath" ]]; then
    source $tmuxCompletionBashPath
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
