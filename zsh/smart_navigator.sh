#! /usr/bin/env bash

function tmux-select-pane() {
    TMUX_REMOTE_PORT=9090
    pane_tty=$(tmux display -p '#{pane_tty}')
    is_vim="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?g?(view|n?vim?x?)(diff)?$'"
    is_ssh="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?ssh$'"
    if [[ -n "$TMUX" ]]; then
        if eval "$is_vim"; then
            tmux display "in vim"
            case $1 in
                -L) tmux send-key C-w h ;;
                -D) tmux send-key C-w j ;;
                -U) tmux send-key C-w k ;;
                -R) tmux send-key C-w l ;;
            esac
        elif eval "$is_ssh"; then
            tmux display "in ssh (local)"
            case $1 in
                -L) tmux send-prefix && tmux send-key h && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -D) tmux send-prefix && tmux send-key j && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -U) tmux send-prefix && tmux send-key k && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -R) tmux send-prefix && tmux send-key l && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
            esac
        elif [[ -n "$SSH_TTY" ]]; then
            tmux display "in ssh (remote)"
            cmd=""
            case $1 in
                -L) [ $(tmux display -p '#{pane_at_left}'   ) = 1 ] && cmd="tmux select-pane -L" || tmux select-pane -L ;;
                -D) [ $(tmux display -p '#{pane_at_bottom}' ) = 1 ] && cmd="tmux select-pane -D" || tmux select-pane -D ;;
                -U) [ $(tmux display -p '#{pane_at_top}'    ) = 1 ] && cmd="tmux select-pane -U" || tmux select-pane -U ;;
                -R) [ $(tmux display -p '#{pane_at_right}'  ) = 1 ] && cmd="tmux select-pane -R" || tmux select-pane -R ;;
            esac
            echo $cmd | nc -N localhost ${TMUX_REMOTE_PORT}
        else
            tmux select-pane $1
        fi
    else
        echo "not in tmux"
    fi
    return 0
}

function ssh(){
    TMUX_REMOTE_PORT=9090
    /usr/bin/ssh -R ${TMUX_REMOTE_PORT}:localhost:${TMUX_REMOTE_PORT} $@
}

if [[ "$1" == "select-pane" ]]; then
    tmux-select-pane $2
fi

if [[ "$1" == "" ]] && [[ -n "$TMUX" ]]; then
    TMUX_REMOTE_PORT=9090
    SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd -P)"
    SCRIPT_PATH="${SCRIPT_DIR}/$(basename $0)"
    tmux bind-key h run "bash ${SCRIPT_PATH} select-pane -L"
    tmux bind-key j run "bash ${SCRIPT_PATH} select-pane -D"
    tmux bind-key k run "bash ${SCRIPT_PATH} select-pane -U"
    tmux bind-key l run "bash ${SCRIPT_PATH} select-pane -R"
fi
