#! /usr/bin/env zsh

if [ -z ${DOTFILES_HOME:+} ]; then
    DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
fi
source $DOTFILES_HOME/lib/utils.sh

function main() {
    if [ "$TMUX" != "" ]; then
        tmux_version=$(tmux -V | sed 's/tmux \([0-9]\.[0-9][a-z]*\)/\1/')
        minimum_required="3.3"
        if verlt $tmux_version $minimum_required; then
            $DOTFILES_HOME/bin/history_search.sh "$1"
        else
            height=$(tmux display -p "#{window_height}" | awk '{ print int(0.8 * $1) }' )
            width=$(tmux display -p "#{window_width}" | awk '{ print int(0.8 * $1) }' )
            fifo_path="/tmp/fifo_$(tmux display -p "#{pane_id}")"
            if [[ -e $fifo_path ]]; then
                rm $fifo_path
            fi
            mkfifo $fifo_path
            tmux display-popup -E -h $height -w $width "$DOTFILES_HOME/bin/history_search.sh $1 > $fifo_path" &
            cat $fifo_path
            rm $fifo_path
        fi
    else
        $DOTFILES_HOME/bin/history_search.sh "$1"
    fi
}

main "$@"

