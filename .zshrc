export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

CASE_SENSITIVE="true"

zstyle ':omz:update' mode auto

plugins=(
    git
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export EDITOR='code -w'