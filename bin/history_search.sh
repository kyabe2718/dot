#! /usr/bin/env zsh

if [[ -o interactive ]]; then
    function main() {
        if type fzf > /dev/null 2>&1; then
            RESULT=$(history -n -r 0 | awk '!a[$0]++ {print $0}' | fzf --layout=reverse --query "$1")
        elif type peco > /dev/null 2>&1; then
            RESULT=$(history -n -r 0 | awk '!a[$0]++ {print $0}' | TERM="screen-255color" peco --query "$1")
        else
            return 1
        fi
        echo $RESULT
        return 0
    }
    main "$@"
    exit
else
    /bin/zsh -i $0 $@
    # -i : force interactive mode
    # history command is valid only in interactive mode. See man zshbuiltins(1).
fi

