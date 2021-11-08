#!/bin/zsh
# Path to your oh-my-zsh installation.

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fino-time"
plugins=( z git github python zsh-autosuggestions docker zsh-syntax-highlighting tmux )

# User configuration
# export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/packer:/Users/i844059/.chefdk/gem/ruby/2.1.0/bin:/opt/vmware/appcatalyst/bin:/Applications/VMware Fusion.app/Contents/Library"
source $ZSH/oh-my-zsh.sh

# This is where we setup the aliases
alias ll='ls -lha'
alias zz="source ~/.zshrc"


export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# funtion to cd and list
function cs () {
    cd "$@" && ls -lha
}


# eval "$(chef shell-init zsh)"
