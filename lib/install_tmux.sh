#! /usr/bin/env bash

set -eu

source $DOTFILES_HOME/lib/utils.sh

function install_tmux(){
    case "$(get_platform)" in
        "Ubuntu")
            if [ ! type tmux > /dev/null 2>&1 ]; then
                sudo apt install tmux
            else
                echo "tmux is already installed. path: $(which tmux) version: $(tmux -V)"
            fi
            ;;
        *) echo "failed to install tmux: Unknown platform $(get_platform)" ;;
    esac

    echo "Create Symlink..."
    mkdir -p $HOME/.tmux
    ln -sfv $DOTFILES_HOME/tmux/config $HOME/.tmux/
}

