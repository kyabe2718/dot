#! /usr/bin/env bash

set -u

DOTFILES_HOME=$(cd $(dirname $0); pwd -P)
echo "DOTFILES_HOME: ${DOTFILES_HOME}"

source ${DOTFILES_HOME}/lib/link_dot.sh

function main() {
    backup_dot
    create_dot_symlink

    ${DOTFILES_HOME}/tmux/install_tmux.sh
    ${DOTFILES_HOME}/nvim/install_nvim.sh
    ${DOTFILES_HOME}/zsh/install_zsh.sh
}

echo $(get_dot_list)

main "$@"
