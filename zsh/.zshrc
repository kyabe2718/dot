#! /usr/bin/env zsh

# zmodload zsh/zprof # to profile

# echo "SCRIPT_PATH: ${(%):-%N}" # man zshmisc
SCRIPT_DIR=$(cd $(dirname $(readlink -f ${(%):-%N})); pwd -P)
export DOTFILES_HOME=$(cd $(dirname $(readlink -f ${(%):-%N}))/..; pwd -P)

export LANG=ja_JP.UTF-8
export PATH=$HOME/.local/bin:$PATH
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME=$HOME/.config
export PATH=$DOTFILES_HOME/bin:$PATH

case ${OSTYPE} in
  darwin*) [ -z "${LSCOLORS}" ] && export LSCOLORS=gxfxcxdxbxegedabagacad ;;
  linux*) [ -z "${LS_COLORS}" ] && eval $(dircolors) ;;
esac

## Mount
mount_points=(
    "$HOME/.cache":"/opt/home/kimura-g/.cache"
    "$HOME/.cargo":"/opt/home/kimura-g/.cargo"
    "$HOME/.rustup":"/opt/home/kimura-g/.rustup"
)
function rebind_if_nfs() {
    local src_dir="$1"
    local dest_dir="$2"

    mkdir -p "$src_dir"
    local fs_type=$(df -T "$src_dir" | awk 'NR==2 {print $2}')

    if [[ $fs_type == nfs* ]]; then
        mkdir -p $dest_dir
        echo "$src_dir is mounted by $fs_type. mount: $src_dir -> $dest_dir"
        sudo mount --bind "$dest_dir" "$src_dir"
    fi
}

if [[ $(hostname) != takaoka* ]]; then
    for entry in ${mount_points[@]}; do
        IFS=":" read -r src_dir dest_dir <<< "$entry"
        rebind_if_nfs "$src_dir" "$dest_dir"
    done
fi


DOTFILES_HOME=$(cd $(dirname $(readlink -f $HOME/.zshrc))/..; pwd -P)

# autoload ... [name]
# Search the function from $FPATH and load it
# # See the section `Autoloading Functions` in zshmisc(1) for full details
#   -U: suppress alias expansion
#   -X: immediately load and execute the function
#   +X: load the function but does not execute it
#   -z, -k: specify autoloading style (zsh or ksh)

autoload -Uz compinit; compinit # Initialize completion. See zshcompsys(1) for more details.
autoload -Uz colors; colors # colorsの使用

# See zshoptions(1)
setopt CORRECT # Try to correct the spelling of commands
setopt IGNORE_EOF # Do not exit on EOF. Require the 'exit' or 'logout'
setopt NO_BEEP
setopt AUTO_MENU # Automatically use menu completion

# Set vim-like key bindings. See zshzle(1) for more details.
bindkey -d # Delete all existing keymaps and reset to the default state
bindkey -v # Set 'viins' as default

alias vi='vim --noplugin'
alias vim='nvim'
alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
alias d='du -h -d1'
alias grep='grep --color=auto'
alias ggrep='grep -RnE1'

wsl_open() {
    if [ $# -eq 0 ]; then
        explorer.exe .
    elif [ $# -eq 1 ]; then
        explorer.exe "$@"
    else
        cmd.exe /c start $(wslpath -w ${path_name}) 2> /dev/null
    fi
}

[[ -n "$WSL_DISTRO_NAME" ]] && alias open='wsl_open' || alias open='xdg-open'

case ${OSTYPE} in
    darwin*) alias ls='ls -G';;
    linux*) alias ls='ls --color=auto';;
esac
alias ll='ls -alF'
alias lh='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls'
alias LS='ls'

alias ip='ip -c'
alias global_ip='curl inet-ip.info'

alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack
alias -s {png,jpg,bmp,pdf,PNG,JPG,BMP,PDF,mkv}=xdg-open
alias -s {com,jp,html}=google-chrome

source $SCRIPT_DIR/scripts/history_config.sh
source $SCRIPT_DIR/scripts/prompt_config.sh
source $SCRIPT_DIR/scripts/completion_config.sh
source $SCRIPT_DIR/scripts/vi_copy_paste.sh
source $SCRIPT_DIR/scripts/smart_navigator.sh

[ -e $HOME/.zshrc.local ] &&  source $HOME/.zshrc.local
[ -e $HOME/.env.sh ] &&  source $HOME/.env.sh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# zprof # to profile

