#! /usr/bin/env zsh

#------------------------------------------------------------
# PROMPT
#------------------------------------------------------------
# %~  カレントディレクトリ(homeを~で表す)
# %n  ユーザー名
# %m  ホスト名
# %# ユーザー種別
# %*  時間(HH:MM:SS)
# 参考 http://www.sirochro.com/note/terminal-zsh-prompt-customize/
#      https://qiita.com/mollifier/items/8d5a627d773758dd8078

# プロンプトにvcsの情報を表示する
# 参考 https://qiita.com/yasuto777/items/f3bd6cffd418f3830b75
#      https://qiita.com/ono_matope/items/55d9dac8d30b299f590d
#      https://qiita.com/mollifier/items/8d5a627d773758dd8078

#hook関数を使えるようにする
# https://qiita.com/mollifier/items/558712f1a93ee07e22e2
#hook名             呼び出される条件
#chpwd              カレントディレクトリが変更したとき
#periodic           プロンプトを表示するたびに、$PERIOD秒ごと
#precmd             プロンプトを表示する直前
#preexec            Enterを押してコマンドを実行する直前
#zshaddhistory      コマンドラインがヒストリに追加される直前
#zshexit            zshを終了する直前
#zsh_directory_name Dynamic named directoriesによるディレクトリ名変換

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:*' formats ' %b|%s'
zstyle ':vcs_info:*' actionformats ' %b|%a|%s'
function _vcs_precmd () { vcs_info }
add-zsh-hook precmd _vcs_precmd
# gitリポジトリにいる場合、set-messageフックでgit-config-user関数が呼び出されるように登録
zstyle ':vcs_info:git+set-message:*' hooks git-config-user
# "+vi-<フック名>"関数で、hook_com[misc]にgit config user.emailの結果を代入する
function +vi-git-config-user(){
    hook_com[misc]+=`git config user.email`
}

function set_prompt() {
    # sshかどうかでPROMPTの色を変える
    [ -z ${SSH_TTY:-} ] && PCOLOR="green" || PCOLOR="cyan"
    # case $KEYMAP in main|viins) KM="(INS)";; vicmd) KM="(NOR)";; esac
    PROMPT=" %* %F{cyan}[%~]
%F{$PCOLOR}%n@%m%f%# "
    RPROMPT='%F{white}${vcs_info_msg_0_}'
}
set_prompt

# function zle-line-init zle-keymap-select {
#     set_prompt
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

