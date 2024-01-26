#! /usr/bin/env bash

verlt() {
    [ "$1" = "$2" ] && return 1 || [  "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

install_tmux() {
    if [[ ${OSTYPE} = linux-gnu* ]]; then
        [ -e /etc/os-release ] && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
        . ${os_release}
        if [[ $ID == "ubuntu" ]]; then
            sudo apt install -y \
                pkg-config gcc automake build-essential flex bison libevent-dev libncurses-dev
        else
            echo "Unknown Platform: $ID"
            exit 1
        fi
    else
        echo "Unknown Platform: ${OSTYPE}"
        exit 1
    fi

    BUILD_DIR=/tmp/tmux
    git clone https://github.com/tmux/tmux.git -b 3.3a $BUILD_DIR
    cd $BUILD_DIR
    sh autogen.sh
    ./configure --prefix $HOME/.local && make install
}

check_tmux(){
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

main(){
    if !(check_tmux); then
        install_tmux
    fi

    echo "Create Symlink..."
    mkdir -p $HOME/.tmux

    SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)
    ln -sfv $SCRIPT_DIR/config $HOME/.tmux/
}

main

