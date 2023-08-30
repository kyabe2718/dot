#! /usr/bin/env bash

set -u

if [ -z ${DOTFILES_HOME:+} ]; then
    DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
fi
source $DOTFILES_HOME/lib/utils.sh

function install_tmux() {
    if !(type pkg-config > /dev/null 2>&1); then
        case "$(get_platform)" in
            ubuntu) sudo apt install pkg-config ;;
            *) echo "failed to install pkg-config: Unknown platform $(get_platform)" ;;
        esac
    fi
    BUILD_DIR=/tmp/tmux
    git clone https://github.com/tmux/tmux.git -b 3.3a $BUILD_DIR
    cd $BUILD_DIR
    sh autogen.sh
    ./configure --prefix $HOME/.local && make install
}

function check_tmux(){
    if [ ! type tmux > /dev/null 2>&1 ]; then
        echo "tmux is not installed."
        return 1
    else
        tmux_version=$(tmux -V | sed 's/tmux \([0-9]\.[0-9][a-z]*\)/\1/')
        minimum_required="3.3"
        if verlt $tmux_version $minimum_required; then
            echo "Current tmux version($tmux_version) is not satisfy minimum required($minimum_required)"
            return 1
        else
            return 0
        fi
    fi
}

function main(){
    if !(check_tmux); then
        case "$(get_platform)" in
            ubuntu) install_tmux ;;
            *) echo "failed to install tmux: Unknown platform $(get_platform)" ;;
        esac
    fi

    echo "Create Symlink..."
    mkdir -p $HOME/.tmux
    ln -sfv $DOTFILES_HOME/tmux/config $HOME/.tmux/
}

main

