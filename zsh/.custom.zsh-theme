#!/usr/bin/env zsh
setopt promptsubst
autoload -U add-zsh-hook

PROMPT='$(__prompt_time) $(__prompt_userinfo)$(__prompt_host) $(__promtp_path) $(git_prompt_info) $(__promtp_symbol) '

ZSH_THEME_GIT_PROMPT_PREFIX=" ⨕ %{$fg[white]%}git %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%} ⊙ %{$reset_color%}"

function __prompt_color(){
    __PREFIX="%{$fg[$1]%}"
    __SUFIX="%{$reset_color%}"
    echo "${__PREFIX}$2${__SUFIX}"
}

function __prompt_time(){
    echo $(__prompt_color "magenta" "%T");
}

function __prompt_host(){
    echo $(__prompt_color "yellow" "%m");
}

function __prompt_userinfo(){
    echo $(__prompt_color "green" "%n@");
}

function __promtp_path(){
    echo $(__prompt_color "red" "[%~]");
}

function __promtp_symbol(){
    if [ $EUID -ne 0 ]; then
        echo $(__prompt_color "yellow" " ==> ");
    else
        echo $(__prompt_color "cyan" "#");
    fi
}

function __prompt_proxy(){
    if [ $(env 2>&1 | grep -i https_proxy 2>&1 >/dev/null; echo $?) -eq 0 ]; then
        if [ $( echo $RPS1 2>&1 | grep -i proxy >/dev/null; echo $?) -eq 1 ]; then
            RPS1="$RPS1 <proxy: $http_proxy>"
        fi
    else
        RSP1=$( (echo $RPS1 2>&1 | sed -E 's|<proxy.+>||g' 2>/dev/null) || (echo $RPS1 2>&1 | sed -r 's|<proxy.+>||g' 2>/dev/null)  )
    fi
}

__prompt_proxy

