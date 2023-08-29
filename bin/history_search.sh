#! /usr/bin/env zsh
set -u

if [ -z ${DOTFILES_HOME:+} ]; then
    DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
fi
source $DOTFILES_HOME/lib/utils.sh

function history_search() {
    QUERY=$1
    if type fzf > /dev/null 2>&1; then
        tmux_version=$(tmux -V | sed 's/tmux \([0-9]\.[0-9][a-z]*\)/\1/')
        minimum_required="3.3"
        if verlt $tmux_version $minimum_required; then
            RESULT=$(history -n -r 0 | awk '!a[$0]++' | fzf-tmux --layout=reverse --query "$QUERY")
        else
            RESULT=$(history -n -r 0 | awk '!a[$0]++' | fzf-tmux -p 80% --layout=reverse --query "$QUERY")
        fi
    elif type peco > /dev/null 2>&1; then
        RESULT=$(history -n -r 0 | awk '!a[$0]++' | peco --query "$QUERY")
    else
        return 1
    fi
    echo $RESULT
    return 0
}

history_search "$@"

