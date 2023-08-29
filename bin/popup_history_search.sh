#! /usr/bin/env zsh

if [ -z ${DOTFILES_HOME:+} ]; then
    DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
fi
source $DOTFILES_HOME/lib/utils.sh

function main() {
    if type tmux > /dev/null 2>&1; then
        tmux_version=$(tmux -V | sed 's/tmux \([0-9]\.[0-9][a-z]*\)/\1/')
        minimum_required="3.3"
        if verlt $tmux_version $minimum_required; then
            echo "use tmux pane"
            # use tmux pane
        else
            height=$(tmux display -p "#{window_height}" | awk '{ print int(0.8 * $1) }' )
            width=$(tmux display -p "#{window_width}" | awk '{ print int(0.8 * $1) }' )
            fifo_name="/tmp/fifo_$(tmux display -p "#{pane_id}")"
            mkfifo $fifo_name
            tmux display-popup -E -h $height -w $width "$DOTFILES_HOME/bin/history_search.sh $1 > $fifo_name" &
            cat $fifo_name
            rm $fifo_name
        fi
    else
        RESULT=$($DOTFILES_HOME/bin/history_search.sh "$1")
        echo $RESULT
    fi
}

main "$@"

