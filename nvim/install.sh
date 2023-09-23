#! /usr/bin/env bash

install_nvim(){
    if [[ ${OS_TYPE} = linux-gnu* ]]; then
        echo "Try to install nvim to $HOME/.local/bin"
        mkdir -p $HOME/.local/bin
        curl -o $HOME/.local/bin/nvim -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x $HOME/.local/bin/nvim
    elif [[ ${OS_TYPE} = darwin* ]]; then
        echo "Try to install nvim using brew"
        brew install nvim
    else
        echo "Failed to install nvim: Unknown Platform: ${OS_TYPE}"
    fi
}

verlt() {
    [ "$1" = "$2" ] && return 1 || [  "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

main() {
    if !(type nvim > /dev/null 2>&1) ; then
        echo "nvim is not found!!"
        install_nvim
    else
        nvim_version=$(nvim --version | grep NVIM | sed 's/NVIM v\([0-9]\.[0-9]\.[0-9]\)/\1/')
        if verlt $nvim_version "0.9.0"; then
            echo "nvim version is less than 0.9.0! Nvim version must be equal to or greater than 0.9.0"
            install_nvim
        fi
    fi

    SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)
    mkdir -p ${XDG_CONFIG_HOME:-"$HOME/.config"}
    ln -sfv $SCRIPT_DIR/nvim ${XDG_CONFIG_HOME:-"$HOME/.config"}
}

main
