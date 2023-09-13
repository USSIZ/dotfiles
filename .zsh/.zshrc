#!/bin/sh 

###############
### EXPORTS ###
###############

export ZDOTDIR=$HOME/.zsh
mkdir -m 700 -p "$ZDOTDIR/plugins"
export HISTFILE=$ZDOTDIR/.zsh_history
export SHELL_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SHELL_SESSION_FILE="$SHELL_SESSION_DIR/$TERM_SESSION_ID.session"

export HISTSIZE=1000
export SAVEHIST=1000

export BROWSER="brave"
#export EDITOR="vim"

###############
### OPTIONS ###
###############

autoload -Uz vcs_info
autoload -Uz colors && colors
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

setopt autocd correct extendedglob prompt_subst

zle_highlight=('paste:none')

###############
### ALIASES ###
###############

alias s='source $HOME/.zsh/.zshrc'

alias c='clear'
alias ll='ls -lah --color'

alias m="git checkout main"
alias d="git checkout dev"

alias zup="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

#################
### FUNCTIONS ###
#################

function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "agkozak/zsh-z"

##############
### PROMPT ###
##############

    ### GIT ###

zstyle ':vcs_info:*' enable git 
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:*' formats '%F{015}{ %F{069}%b %F{015}}%f'

    ### MAIN ###

PROMPT='%K{015} 🦦 %k%F{015}%B%K{069} %n %F{000}at %F{015}%m %k%b in %B%K{069} %~ %k%b%f
%F{015}exit:%B%F{069}%?%b %F{015}>>> %B%F{069}%#%f%b '
RPROMPT="\$vcs_info_msg_0_ %F{015}{ %T }%f"

echo -e -n "\x1b[\x33 q"