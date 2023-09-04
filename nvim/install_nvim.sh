#! /usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $(readlink -f $0)); pwd -P)
source $SCRIPT_DIR/../lib/utils.sh

install_nvim(){
    echo "Try to install nvim to $HOME/.local/bin"
    curl -o $HOME/.local/bin/nvim -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x $HOME/.local/bin/nvim
}

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

ln -sfv $SCRIPT_DIR/nvim ${XDG_CONFIG_HOME:-"$HOME/.config"}


copilot_vim_path="$HOME/.config/nvim/pack/github/start/copilot.vim"
if [[ ! -e $copilot_vim_path ]]; then
    git clone https://github.com/github/copilot.vim.git $copilot_vim_path
fi
