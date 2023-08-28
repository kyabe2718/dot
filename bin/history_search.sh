#! /usr/bin/env zsh

function history_search() {
    QUERY="$1"
    if type fzf > /dev/null 2>&1; then
        # RESULT=$(history -n -r 0 | awk '!a[$0]++' | fzf --layout=reverse --query "$QUERY")
        RESULT=$(history -n -r 0 | awk '!a[$0]++' | fzf-tmux -p 80% --layout=reverse --query "$QUERY")
    elif type peco > /dev/null 2>&1; then
        RESULT=$(history -n -r 0 | awk '!a[$0]++' | peco --query "$QUERY")
    else
        return 1
    fi
    echo $RESULT
    return 0
}

history_search $@

