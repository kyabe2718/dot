#! /usr/bin/env bash

set -u

usage() {
    cat <<EOF
Usage: $(basename $0) [options]
Options:
    --dot     Install dotfiles
    --zsh     Install zsh
    --nvim    Install neovim
    --tmux    Install tmux
    --gpt     Install gpt
    --fonts   Install fonts
    -a, --all Install all (except fonts)
EOF
}

install_dots() {
    dotfiles=""
    for f in $@; do
        [[ -e $f ]] && dotfiles="$dotfiles $f"
    done
    echo $dotfiles

    check_diff() {
        for src in $@; do
            dst=$HOME/$(basename $src)
            if !([[ -e $dst ]] && diff $src $dst > /dev/null 2>&1); then
                return 1
            fi
        done
        return 0
    }

    backup_dot() {
        dotfiles=$@
        local backup_dir="${XDG_CACHE_HOME:-$HOME/.cache}/$(date "+%Y%m%d-%H%M%S")"
        echo "Backup current dotfiles to ${backup_dir}"
        mkdir -p ${backup_dir}
        for f in $dotfiles; do
            f=$(basename $f)
            if [[ -e $HOME/$f ]]; then
                echo "backup: $HOME/$f -> $backup_dir/$f"
                cp $HOME/$f $backup_dir/$f
            fi
        done
    }

    if check_diff $dotfiles; then
        echo "There are no difference..."
    else
        backup_dot $dotfiles
        echo "Create symlinks...."
        for src in $dotfiles; do
            dst=$HOME/$(basename $src)
            ln -sfv $src $dst
        done
    fi
}


main() {
    local targets=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dot)  targets+=("dot");  shift ;;
            --zsh)  targets+=("zsh");  shift ;;
            --nvim) targets+=("nvim"); shift ;;
            --tmux) targets+=("tmux"); shift ;;
            --gpt)  targets+=("gpt");  shift ;;
            --fonts) targets+=("fonts"); shift ;;
            -a|--all)
                targets+=("dot" "zsh" "nvim" "tmux" "gpt"); shift ;;
            -h|--help) usage; exit 0 ;;
            *) echo "Invalid option: $1"; exit 1 ;;
        esac
    done

    DOTFILES_HOME=$(cd $(dirname $0); pwd -P)
    echo "DOTFILES_HOME: ${DOTFILES_HOME}"

    for tgt in ${targets[@]}; do
        echo -e "\nInstall $tgt..."
        if [[ $tgt == "dot" ]]; then
            dotfiles=$(find ${DOTFILES_HOME}/dot -type f)
            dotfiles="$dotfiles ${DOTFILES_HOME}/zsh/.zshrc"
            dotfiles="$dotfiles ${DOTFILES_HOME}/tmux/.tmux.conf"
            install_dots $dotfiles
        else
            ${DOTFILES_HOME}/$tgt/install.sh
        fi
    done

    if [[ "$(uname -r)" == *microsoft-*WSL* ]]; then
        WINDOWS_HOME=$(cmd.exe /C "echo %userprofile%" 2> /dev/null |\
            tr -d '\r' | sed -e 's/C:/\/mnt\/c/' -e 's/\\/\//g')
        [[ -e $WINDOWS_HOME/Downloads ]] || ln -snv $WINDOWS_HOME/Downloads $HOME/Downloads
        [[ -e $WINDOWS_HOME/Documents ]] || ln -snv $WINDOWS_HOME/Documents $HOME/Documents
    fi
}

main "$@"
