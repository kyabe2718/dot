#! /usr/bin/env zsh
# zmodload zsh/zprof # to profile

export LANG=ja_JP.UTF-8
export PATH=$HOME/.local/bin:$PATH
[ -z "$XDG_CONFIG_HOOME" ] && export XDG_CONFIG_HOME=$HOME/.config

case ${OSTYPE} in
  darwin*) [ -z "${LSCOLORS}" ] && export LSCOLORS=gxfxcxdxbxegedabagacad ;;
  linux*) [ -z "${LS_COLORS}" ] && eval $(dircolors) ;;
esac

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
alias open='xdg-open'
alias grep='grep --color=auto'
alias ggrep='grep -RnE1'

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

source $DOTFILES_HOME/zsh/history_config.sh
source $DOTFILES_HOME/zsh/prompt_config.sh
source $DOTFILES_HOME/zsh/completion_config.sh
source $DOTFILES_HOME/zsh/vi_copy_paste.sh
source $DOTFILES_HOME/zsh/smart_navigator.sh

[ -e $HOME/.zshrc.local ] &&  source $HOME/.zshrc.local
[ -e $HOME/.env.sh ] &&  source $HOME/.env.sh

# zprof # to profile
