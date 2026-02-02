#!/bin/zsh
# Path to your oh-my-zsh installation.

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fino-time"
plugins=(
  git
  python
  z
  brew
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# User configuration
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lha'
alias zz='source ~/.zshrc'

# Exports
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Functions
function cs () {
    cd "$@" && ls -lha
}
