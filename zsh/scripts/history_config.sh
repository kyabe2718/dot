#! /usr/bin/env zsh

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS
# setopt EXTENDED_HISTORY # 開始と終了を記録
setopt SHARE_HISTORY


peco-select-history() {
    local RESULT=$($DOTFILES_HOME/bin/tmux-popup.sh -- $DOTFILES_HOME/bin/history_search.sh "$LBUFFER")
    if [ $? = 0 ]; then
        if [ ${#RESULT} != 0 ]; then # 検索結果が存在しなければ元の入力を保存
            CURSOR=${#RESULT} # ${#name}はname変数の文字数に置換される
            BUFFER=${RESULT}
            zle clear-screen # 画面のクリア
        fi
    else # 存在しなければ通常のincremental searchを登録しなおす
        bindkey '\e[3~' delete-char
        bindkey '^R' history-incremental-search-backward
    fi
}

main() {
    zle -N peco-select-history
    bindkey '^r' peco-select-history
}

main
