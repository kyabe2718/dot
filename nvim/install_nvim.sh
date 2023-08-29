#! /bin/bash

SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)

if !(type nvim > /dev/null 2>&1) ; then
    echo "nvim is notfound!! try to install nvim"
    curl -o $HOME/.local/bin/nvim -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x $HOME/.local/bin/nvim
fi

# ln -sfv $SCRIPT_DIR/nvim ${XDG_CONFIG_HOME:-"$HOME/.config"}

