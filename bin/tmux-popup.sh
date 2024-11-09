#! /usr/bin/env zsh

verlt() {
    [ "$1" = "$2" ] && return 1 || [ "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

main() {
    local cmd="$SHELL"
    local opts="-h80% -w80%"
    local redirect=true

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--height)  opts="$opts -h $2"; shift;;
            -w|--width)   opts="$opts -w $2"; shift;;
            -c|--command) cmd=$2; shift;;
            -n|--no-redirect) redirect=false ;;
            --) shift; cmd=$@; break;;
            *)  echo "Unknown option: $1"; exit 1;;
        esac
        shift
    done

    if [[ -z "$cmd" ]] ; then
        echo "No command specified"
        exit 1
    fi

    if [[ -n "$TMUX" ]]; then
        tmux_version=$(tmux -V | sed 's/tmux \([0-9]\.[0-9][a-z]*\)/\1/')
        minimum_required="3.3"
        if verlt $tmux_version $minimum_required; then
            eval "$cmd"
        else
            if [[ ! $redirect ]]; then
                eval "tmux display-popup -E $opts \"$cmd\""
            else
                fifo_path="/tmp/fifo_$(tmux display -p "#{pane_id}")"
                [[ -e $fifo_path ]] && rm $fifo_path
                mkfifo $fifo_path
                eval "tmux display-popup -E $opts \"$cmd | tee $fifo_path\" &"
                cat $fifo_path
                rm $fifo_path
            fi
        fi
    else
        eval $cmd
    fi
}

main "$@"
