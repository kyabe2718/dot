#! /usr/bin/env zsh
#-----------------------------------------------------------
# history
#-----------------------------------------------------------
export HISTFILE=${HOME}/.zsh_history # 履歴ファイルの保存先
export HISTSIZE=10000 # メモリに保存される履歴の件数
export SAVEHIST=100000 # 履歴ファイルに保存される履歴の件数
setopt HIST_IGNORE_DUPS # 重複を記録しない
setopt EXTENDED_HISTORY # 開始と終了を記録
setopt SHARE_HISTORY # 他のターミナルと共有

# C-rで履歴検索
function peco-select-history() {
    RESULT=$(. $DOTFILES_HOME/bin/popup_history_search.sh "$LBUFFER")
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
zle -N peco-select-history
bindkey '^r' peco-select-history
