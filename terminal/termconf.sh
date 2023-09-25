#! /usr/bin/env bash

get_terminal_emulator() {
    pid=$$
    tty
    while true; do
        pid=$(ps -h -o ppid -p $pid 2>/dev/null)
        case $(ps -h -o comm -p $pid 2>/dev/null) in
            (gnome-terminal) echo "gnome-terminal"; return;;
            (xterm) echo "xterm"; return;;
            (rxvt) echo "rxvt"; return;;
        esac
        [[ $pid -le 1 ]] && break
    done
}

main() {
    while [[ $# -gt 0 ]]; do
        arg=$1
        shift
        case $arg in
            help) usage "$@"; exit 0;;
            set) set_config "$@"; exit 0;;
            *) echo "Unknown option: $1" >&2; exit 1;;
        esac
        shift
    done
}

main
