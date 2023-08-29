#! /usr/bin/env bash

set -eu

DOTFILES_HOME=$(cd $(dirname $0); pwd -P)
echo "DOTFILES_HOME: ${DOTFILES_HOME}"

source ${DOTFILES_HOME}/lib/link_dot.sh
source ${DOTFILES_HOME}/lib/install_tmux.sh

function main() {
    # while [[ $# -gt 0 ]]; do
    #     case $1 in
    #     esac
    # done

    backup_dot
    create_dot_symlink

    install_tmux
    ${DOTFILES_HOME}/nvim/install_nvim.sh
}

echo $(get_dot_list)

main "$@"
