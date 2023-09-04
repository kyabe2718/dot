#/usr/bin/env bash

if [ -z ${DOTFILES_HOME:+} ]; then
    DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
fi
source $DOTFILES_HOME/lib/utils.sh

function main() {
    case "$(get_platform)" in
        ubuntu) sudo apt install -y zsh ;;
        *) echo "failed to install tmux: Unknown platform $(get_platform)" ;;
    esac
}

main
