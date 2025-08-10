#!/bin/bash

HIKTOOLS="$(pwd)"

## =============================================================== ##
##   neovim
## =============================================================== ##
export NVIM_HOME="$HIKTOOLS/nvim-linux64"
export PATH="$NVIM_HOME/bin:$PATH"

## =============================================================== ##
##   lunarvim
## =============================================================== ##
# alias vim='${HIKTOOLS}/lvim/lvim'
# export EDITOR=lvim

# export AIDER_EDITOR=lvim
# export AIDER_DARK_MODE=true


## =============================================================== ##
##   tmux config 
## =============================================================== ##
export TMUX_HOME="$HIKTOOLS/tmux"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$TMUX_HOME/lib"
export PATH="$TMUX_HOME/bin:$PATH"

tmux_dir="$HOME/.tmux"
tmux_conf="$HOME/.tmux.conf"

# 检查 .tmux 目录是否存在
if [[ ! -d "$tmux_dir" ]]; then
    echo "Copying .tmux directory..."
    cp -r "$HIKTOOLS/config/.tmux" "$tmux_dir"
fi

# 检查 .tmux.conf 是否存在
if [[ ! -f "$tmux_conf" ]]; then
    echo "Copying .tmux.conf..."
    cp "$HIKTOOLS/config/.tmux.conf" "$tmux_conf"
fi

alias tnew="tmux new -s"
alias tat="tmux attach"
alias ppp="tmux show-buffer | xclip -sel clip -i > /dev/null"
