#! /usr/bin/env bash

# DOTFILES_HOME

function get_dot_list() {
    ret=""
    for f in $(find ${DOTFILES_HOME}/dot -type f); do
        ret="$ret $(basename $f)"
    done
    echo $ret
}

function dry_run() {
    for f in $(get_dot_list); do
        if !([[ -e $HOME/$f ]] && diff ${DOTFILES_HOME}/dot/$f $HOME/$f > /dev/null 2>&1); then
            return 1
        fi
    done
    return 0
}

function backup_dot() {
    if dry_run; then
        echo "There are no difference..."
        return
    fi

    local backup_dir="${XDG_CACHE_HOME:-$HOME/.cache}/$(date "+%Y%m%d-%H%M%S")"
    echo "Backup current dotfiles to ${backup_dir}"
    mkdir -p ${backup_dir}
    for f in $(get_dot_list); do
        if [ -e $HOME/$f ]; then
            cp --verbose $HOME/$f $backup_dir/$f
        fi
    done
}

function create_dot_symlink() {
    echo "Create symlinks...."
    for f in $(get_dot_list); do
        ln -sfv ${DOTFILES_HOME}/dot/$f $HOME/$f
    done
}

