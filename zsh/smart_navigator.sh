#! /usr/bin/env bash

function tmux-select-pane() {
    TMUX_REMOTE_PORT=9090
    pane_tty=$(tmux display -p '#{pane_tty}')
    is_vim=$(ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$')
    is_ssh=$(ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?ssh$')
    echo "is_vim: $is_vim"
    echo "is_ssh: $is_ssh"
    if [[ -n "$TMUX" ]]; then
        if [[ -n "${is_vim}" ]]; then
            echo "in vim"
            case $1 in
                -L) tmux send-key C-w h ;;
                -D) tmux send-key C-w j ;;
                -U) tmux send-key C-w k ;;
                -R) tmux send-key C-w l ;;
            esac
        elif [[ -n "${is_ssh}" ]]; then
            echo "in ssh (local)"
            case $1 in
                -L) tmux send-prefix && tmux send-key h && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -D) tmux send-prefix && tmux send-key j && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -U) tmux send-prefix && tmux send-key k && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
                -R) tmux send-prefix && tmux send-key l && eval $(nc -l ${TMUX_REMOTE_PORT}) ;;
            esac
        elif [[ -n "$SSH_TTY" ]]; then
            echo "in ssh (remote)"
            case $1 in
                -L) [ $(tmux display -p '#{pane_at_left}'   ) = 1 ] && echo "tmux select-pane -L" | nc localhost ${TMUX_REMOTE_PORT} || tmux select-pane -L ;;
                -D) [ $(tmux display -p '#{pane_at_bottom}' ) = 1 ] && echo "tmux select-pane -D" | nc localhost ${TMUX_REMOTE_PORT} || tmux select-pane -D ;;
                -U) [ $(tmux display -p '#{pane_at_top}'    ) = 1 ] && echo "tmux select-pane -U" | nc localhost ${TMUX_REMOTE_PORT} || tmux select-pane -U ;;
                -R) [ $(tmux display -p '#{pane_at_right}'  ) = 1 ] && echo "tmux select-pane -R" | nc localhost ${TMUX_REMOTE_PORT} || tmux select-pane -R ;;
            esac
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

if [[ -n "$TMUX" ]]; then
    # SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd -P)"
    # tmux bind-key h run ". $SCRIPT_DIR/smart_navigator.sh"
    # tmux bind-key j run ". $SCRIPT_DIR/smart_navigator.sh"
    # tmux bind-key k run ". $SCRIPT_DIR/smart_navigator.sh"
    # tmux bind-key l run ". $SCRIPT_DIR/smart_navigator.sh"
fi
