#! /usr/bin/env bash

set -e

#
# in 'echo'
#   \0NNN byte with octal value NNN (1 to 3 digits)
#   \xHH  byte with hexadecimal value HH (1 to 2 digits)
# in 'printf'
#   \NNN byte with octal value NNN (1 to 3 digits)
#   \xHH byte with hexadecimal value HH (1 to 2 digits)
# in 'GNU sed'
#   \oNNN byte with octal value NNN (1 to 3 digits)
#   \xHH byte with hexadecimal value HH (1 to 2 digits)
#
# We basically use \xHH for compatibility
#

function tmux_passthrough() {
    local seq=$(sed -e 's/\x1B/\x1B\x1B/g' <<< "$1")
    printf '\033Ptmux;%s\033\\' "$seq"
}

function print_seq() {
    if [[ -n "$TMUX" ]]; then
        echo "in tmux"
        tmux_passthrough "$1"
    else
        echo "not in tmux"
        printf '%s' "$1"
    fi
}

function usage() {
    echo "Usage: hoge.sh [options]"
}

function set-title() {
    echo "set title to $1"
    local s=$(printf '\x1B]0;%s\a' "$1")
    # print_seq $(print_seq "$s")
    print_seq "$s"
}

function copy-to-clipboard() {
    echo "copy to clipboard: $1"
    local s=$(echo -n "$1" | base64 | tr -d '\n')
    local s=$(printf '\x1B]52;c;%s\a' "$s")
    print_seq "$s"
}

function rename() {
    if [[ -n "$TMUX" ]]; then
        printf '\x1Bk%s\a' "$1"
    else
        echo "failed to rename pane title: not in tmux"
        exit 1
    fi
}

function message-hogehoge() {
    echo "unkoooo"
    tmux set -g user-keys[0] '\x1B]foobar'
    tmux bind-key -Troot User0 display-message "hogehoge"
    # local s='\x1B]5000;hogehoge\a'
    # print_seq "$s"
}

function main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help) usage; exit 0 ;;
            -c|--copy)      shift; copy-to-clipboard "$@";      exit 0 ;;
            -r|--rename)    shift; rename "$@";     exit 0 ;;
            -t|--set-title) shift; set-title "$@";  exit 0 ;;
            -m) message-hogehoge;  exit 0 ;;
            *) echo "Invalid option: $1"; exit 1 ;;
        esac
        shift
    done
}

main "$@"
