#! /usr/bin/env zsh

main() {
    case ${OSTYPE} in
        linux-gnu*)
            if [[ ! -e /tmp/nerd-fonts ]]; then
                git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts
            fi
            cd /tmp/nerd-fonts
            if [[ "$(uname -r)" == *microsoft-*WSL* ]]; then
                for font in JetBrainsMono UbuntuMono Hack; do
                    yes R | powershell.exe -ExecutionPolicy Unrestricted -File ./install.ps1 $font -WhatIf
                done
            else
                echo "Unknown Platform"
                exit 1
                # mkdir -p $HOME/.fonts && mv *.ttf $HOME/.fonts
            fi
            ;;
        darwin*)
            brew tap homebrew/cask-fonts
            brew install font-hack-nerd-font font-jetbrains-mono-font
            ;;
        *) echo "Unknown Platform"; exit 1;;
    esac
}

main

