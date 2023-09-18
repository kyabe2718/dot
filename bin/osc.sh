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


function print_seq() {
    local s="$@"
    for i in $(seq 1 $NEST_TMUX_LEVEL); do
        s=$(sed -e 's/\x1B/\x1B\x1B/g' <<< "$s")
        s=$(printf '\x1BPtmux;%s\x1B\\' "$s")
    done
    printf '%s' "$s"
}

function print_osc() {
    local NUM="$1"; shift
    [[ "$DEBUG" = 1 ]] && (print_seq $(printf '\x1B]%d;%s\x07' "$NUM" "$@") | cat -v)
    print_seq $(printf '\x1B]%d;%s\x07' "$NUM" "$@")
}

function window-rename() {
    [[ $DEBUG = 1 ]] && echo "$NEST_TMUX_LEVEL"
    if [[ $NEST_TMUX_LEVEL < 1 ]]; then
        echo "failed to rename window title: not in tmux"
        exit 1
    else
        NEST_TMUX_LEVEL=$((NEST_TMUX_LEVEL-1))
        print_seq $(printf '\x1Bk%s\a' "$1")
    fi
}

function watch-osc() {
    PATTERN='\x1B]\([0-9]*\);\(.*\)\x07'
    # for i in $(seq 1 $NEST_TMUX_LEVEL); do
    #     PATTERN='\x1BPtmux;'$(sed -e 's/\\x1B/\\x1B\\x1B/g' <<< "$PATTERN")'\x1B\\'
    # done
    function osc_hook(){
        local osc_num=$1; shift
        case $osc_num in
            51234) eval "tmux $(echo -n $@ | base64 -d)" ;;
            # *) echo "unknown osc[$osc_num]: $@" ;;
        esac
    }

    cat "$1" | sed --unbuffered -n "$(printf 's/^.*%s.*$/\\1 \\2/pg' "$PATTERN")" | while read -r args; do
        osc_hook $args
    done
}

function main() {
    [[ -n "$TMUX" ]] && NEST_TMUX_LEVEL=1 || NEST_TMUX_LEVEL=0
    OSC_NUM=""; OSC_CONTENT=""; DEBUG=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--copy)      shift; OSC_NUM=52; OSC_CONTENT="c;$(echo -n "$1" | base64 | tr -d '\n')" ;;
            -t|--set-title) shift; OSC_NUM=0;  OSC_CONTENT="$1"         ;;
            --tmux)         shift; OSC_NUM=51234; OSC_CONTENT="$(echo -n "$1" | base64 | tr -d '\n')" ;;
            --osc-num)      shift; OSC_NUM="$1"; ;;
            --osc-content)  shift; OSC_CONTENT="$1";;
            # -r|--rename)    shift; ;;
            -w|--watch)     shift; watch-osc "$1" exit 0 ;;
            --tmux-nest)    shift; NEST_TMUX_LEVEL="$1"  ;;
            --debug)        DEBUG=1                      ;;
            -h|--help)
                echo "Usage: $0 [options]"
                exit 0 ;;
            *) echo "Invalid option: $1"; exit 1 ;;
        esac
        shift
    done

    if [[ -n "$OSC_NUM" ]]; then
        [[ "$DEBUG" = 1 ]] && echo "$OSC_NUM" "$OSC_CONTENT"
        print_osc "$OSC_NUM" "$OSC_CONTENT"
    fi
}

main "$@"
