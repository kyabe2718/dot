#! /usr/bin/env zsh


# See man zshcompsys(1)
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

# 補完の大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'



