#! /usr/bin/env bash

function to_hjkl() {
    case $1 in
        L) echo "h";;
        D) echo "j";;
        U) echo "k";;
        R) echo "l";;
        *) echo "$1";;
    esac
}

function to_LDUR() {
    case $1 in
        h) echo "L";;
        j) echo "D";;
        k) echo "U";;
        l) echo "R";;
        *) echo "$1";;
    esac
}

function main() {
    dir=$1

    # in tmux in ssh
    if [ -n "${SSH_TTY}" ] && [ -n "${TMUX}" ]; then
        tmux select-pane -$(to_LDUR ${dir})
    fi

    # in tmux
    if [ -n "${TMUX}" ]; then
        tmux select-pane -$(to_LDUR ${dir})
    fi
}

main "$@"
