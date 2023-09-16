#! /usr/bin/env zsh

# function tmux-select-pane() {
#     local DIR=""
#     local TMUX_SELECT_PANE_SEND_PORT=""
#     local TMUX_SELECT_PANE_LISTEN_PORT=""
#     while [[ $# -gt 0 ]]; do
#         case $1 in
#             -d | --direction) shift; DIR=$1 ;;
#             -p | --send-port) shift; TMUX_SELECT_PANE_SEND_PORT=$1 ;;
#             -l | --listen-port) shift; TMUX_SELECT_PANE_LISTEN_PORT=$1 ;;
#             -h | --help) echo "Usage: tmux-select-pane [-d direction] [-p send-port] [-l listen-port]"; return 0 ;;
#             *) echo "invalid argument: $1" && return 1 ;;
#         esac
#         shift
#     done
#
#     [[ -z "$DIR" ]] && return 1
#     [[ -z "$TMUX_SELECT_PANE_SEND_PORT" ]] && return 1
#     [[ -z "$TMUX_SELECT_PANE_LISTEN_PORT" ]] && return 1
#
#     if [[ -n "$TMUX" ]]; then
#         is_vim="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?g?(view|n?vim?x?)(diff)?$'"
#         is_ssh="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?ssh$'"
#         if eval "$is_vim"; then
#             # tmux display "in vim"
#             case $DIR in
#                 l|left)  tmux send-key C-w h ;;
#                 d|down)  tmux send-key C-w j ;;
#                 u|up)    tmux send-key C-w k ;;
#                 r|right) tmux send-key C-w l ;;
#             esac
#         elif eval "$is_ssh"; then
#             # tmux display "in ssh (local)"
#             case $DIR in
#                 l|left)  tmux send-prefix && tmux send-key h && eval $(timeout 1 nc -l ${TMUX_SELECT_PANE_LISTEN_PORT}) ;;
#                 d|down)  tmux send-prefix && tmux send-key j && eval $(timeout 1 nc -l ${TMUX_SELECT_PANE_LISTEN_PORT}) ;;
#                 u|up)    tmux send-prefix && tmux send-key k && eval $(timeout 1 nc -l ${TMUX_SELECT_PANE_LISTEN_PORT}) ;;
#                 r|right) tmux send-prefix && tmux send-key l && eval $(timeout 1 nc -l ${TMUX_SELECT_PANE_LISTEN_PORT}) ;;
#             esac
#         elif [[ -n "$SSH_TTY" ]]; then
#             # tmux display "in ssh (remote)"
#             cmd=""
#             case $DIR in
#                 l|left)  [ $(tmux display -p '#{pane_at_left}'   ) = 1 ] && cmd="tmux select-pane -L" || tmux select-pane -L ;;
#                 d|down)  [ $(tmux display -p '#{pane_at_bottom}' ) = 1 ] && cmd="tmux select-pane -D" || tmux select-pane -D ;;
#                 u|up)    [ $(tmux display -p '#{pane_at_top}'    ) = 1 ] && cmd="tmux select-pane -U" || tmux select-pane -U ;;
#                 r|right) [ $(tmux display -p '#{pane_at_right}'  ) = 1 ] && cmd="tmux select-pane -R" || tmux select-pane -R ;;
#             esac
#             echo $cmd | nc -N localhost ${TMUX_SELECT_PANE_SEND_PORT}
#         else
#             case $DIR in
#                 l|left)  tmux select-pane -L ;;
#                 d|down)  tmux select-pane -D ;;
#                 u|up)    tmux select-pane -U ;;
#                 r|right) tmux select-pane -R ;;
#             esac
#         fi
#     else
#         echo "not in tmux"
#     fi
#     return 0
# }

function tmux-select-pane() {
    local DIR=""
    local LISTEN=0
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d | --direction) shift; DIR=$1 ;;
            -l | --listen) LISTEN=1 ;;
            -h | --help) echo "Usage: tmux-select-pane [-d direction] [-l]"; return 0 ;;
            *) echo "invalid argument: $1" && return 1 ;;
        esac
        shift
    done

    if [[ $LISTEN = 1 ]]; then
        pane_id=$(tmux display -p '#{pane_id}')
        cat >> $HOME/lines_${pane_id}.log
        # while read LINE; do
        #     echo $LINE >> $HOME/lines_${pane_id}.log
        #     content= $(echo $LINE | sed -e "s/\033]\(\)\007/\1/g")
        #     if [[ -n "$content" ]]; then
        #         echo $content >> $HOME/content_${pane_id}.log
        #     fi
        # done
        return 0
    fi

    pane_tty=$(tmux display -p '#{pane_tty}')
    if [[ -n "$TMUX" ]]; then
        is_vim="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?g?(view|n?vim?x?)(diff)?$'"
        is_ssh="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?ssh$'"
        if eval "$is_vim"; then
            # tmux display "in vim"
            case $DIR in
                l|left)  tmux send-key C-w h ;;
                d|down)  tmux send-key C-w j ;;
                u|up)    tmux send-key C-w k ;;
                r|right) tmux send-key C-w l ;;
            esac
        elif eval "$is_ssh"; then
            # tmux display "in ssh (local)"
            case $DIR in
                l|left)  tmux send-prefix && tmux send-key h ;;
                d|down)  tmux send-prefix && tmux send-key j ;;
                u|up)    tmux send-prefix && tmux send-key k ;;
                r|right) tmux send-prefix && tmux send-key l ;;
            esac
        elif [[ -n "$SSH_TTY" ]]; then
            # tmux display "in ssh (remote)"
            cmd=""
            case $DIR in
                l|left)  [ $(tmux display -p '#{pane_at_left}'   ) = 1 ] && cmd="tmux select-pane -L" || tmux select-pane -L ;;
                d|down)  [ $(tmux display -p '#{pane_at_bottom}' ) = 1 ] && cmd="tmux select-pane -D" || tmux select-pane -D ;;
                u|up)    [ $(tmux display -p '#{pane_at_top}'    ) = 1 ] && cmd="tmux select-pane -U" || tmux select-pane -U ;;
                r|right) [ $(tmux display -p '#{pane_at_right}'  ) = 1 ] && cmd="tmux select-pane -R" || tmux select-pane -R ;;
            esac
            [[ -n "$cmd" ]] && echo -en "\ePtmux;\e\e]5000;$cmd\a\e\\" > $pane_tty
        else
            case $DIR in
                l|left)  tmux select-pane -L ;;
                d|down)  tmux select-pane -D ;;
                u|up)    tmux select-pane -U ;;
                r|right) tmux select-pane -R ;;
            esac
        fi
    else
        echo "not in tmux"
    fi
    return 0
}

echo "$@" >> $HOME/log.log
tmux-select-pane "$@"
