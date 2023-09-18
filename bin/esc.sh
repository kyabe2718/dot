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
    printf '\x1BPtmux;%s\x1B\\' "$seq"
}

function print_seq() {
    [[ $DEBUG = 1 ]] && echo "tmux nest level: $NEST_TMUX_LEVEL"
    local s="$1"
    for i in $(seq 1 $NEST_TMUX_LEVEL); do
        s=$(tmux_passthrough "$s")
    done
    [[ $DEBUG = 1 ]] && (echo -n "output: " > /dev/stderr; printf '%s' "$s" | cat -v > /dev/stderr)
    printf '%s' "$s"
}

function usage() {
    echo "Usage: esc.sh [options] [text]"
}

function set-title() {
    [[ $DEBUG = 1 ]] && echo "set title to $1"
    local s=$(printf '\x1B]0;%s\a' "$1")
    print_seq "$s"
}

function copy-to-clipboard() {
    [[ $DEBUG = 1 ]] && echo "copy to clipboard: $1"
    local s=$(echo -n "$1" | base64 | tr -d '\n')
    local s=$(printf '\x1B]52;c;%s\a' "$s")
    print_seq "$s"
}

function window-rename() {
    [[ $DEBUG = 1 ]] && echo "$NEST_TMUX_LEVEL"
    if [[ $NEST_TMUX_LEVEL < 1 ]]; then
        echo "failed to rename window title: not in tmux"
        exit 1
    else
        [[ $DEBUG = 1 ]] && echo "rename window title to $1"
        NEST_TMUX_LEVEL=$((NEST_TMUX_LEVEL-1))
        print_seq $(printf '\x1Bk%s\a' "$1")
    fi
}

function extract_osc() {

    # sed -n 's/.../.../p' # マッチした行のみ出力

    PATTERN='\x1B]\([0-9]*\);\(.*\)\x07'
    for i in $(seq 1 $NEST_TMUX_LEVEL); do
        PATTERN='\x1BPtmux;'$(sed -e 's/\\x1B/\\x1B\\x1B/g' <<< "$PATTERN")'\x1B\\'
    done

    function hoge() {
        echo "NUMBER:  $1" | cat -v
        echo $1 | od -x
        echo "COMMAND: $2" | cat -v
    }

    SED=$(printf 's/%s/\\1 \"\\2\"\\n/p' "$PATTERN")
    # cat "$1" | sed -n "$SED" | cat -v
    cat "$1" | sed -n "$SED" | while read -r line; do
        # echo "$line"
        eval "hoge $line"
    done
}

function main() {
    [[ -n "$TMUX" ]] && NEST_TMUX_LEVEL=1 || NEST_TMUX_LEVEL=0
    CMDS=()
    DEBUG=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help) usage; exit 0 ;;
            -c|--copy)        shift; CMDS+=("copy-to-clipboard $1") ;;
            -r|--rename)      shift; CMDS+=("window-rename $1")     ;;
            -t|--set-title)   shift; CMDS+=("set-title $1")         ;;
            --osc)            shift; CMDS+=("extract_osc $1")       ;;
            --force-in-tmux)  NEST_TMUX_LEVEL=1                     ;;
            --tmux-nest)      shift; NEST_TMUX_LEVEL="$1"           ;;
            --debug)          DEBUG=1                       ;;
            *) echo "Invalid option: $1"; exit 1 ;;
        esac
        shift
    done
    [[ $DEBUG = 1 ]] && echo "NEST_TMUX_LEVEL: $NEST_TMUX_LEVEL"
    for cmd in "${CMDS[@]}"; do
        echo "cmd: $cmd"
        eval "$cmd"
    done
}

main "$@"
