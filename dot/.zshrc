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

export LANG=ja_JP.UTF-8 # 文字コードをutf-8に

# if $LSCOLORS is not defined
if [ -z $LSCOLORS ]; then
    export LSCOLORS=gxfxcxdxbxegedabagacad
fi

# See zshoptions(1)
setopt CORRECT # Try to correct the spelling of commands
setopt IGNORE_EOF # Do not exit on EOF. Require the 'exit' or 'logout'
setopt NO_BEEP
setopt AUTO_MENU # Automatically use menu completion

# Set vim-like key bindings. See zshzle(1) for more details.
bindkey -d # Delete all existing keymaps and reset to the default state
bindkey -v # Set 'viins' as default

source $DOTFILES_HOME/zsh/history_config.sh
source $DOTFILES_HOME/zsh/prompt_config.sh
source $DOTFILES_HOME/zsh/completion_config.sh
source $DOTFILES_HOME/zsh/vi_copy_paste.sh

# install zsh-vi-mode
if [ ! -d $HOME/.local/share/zsh-vi-mode ]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.local/share/zsh-vi-mode
fi
source $HOME/.local/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

for f in $HOME/.shellrc.??*; do
    source $f
done

if [ -e $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

#-----------------------------------------------------------
# 参考
#-----------------------------------------------------------
# http://post.simplie.jp/posts/60
# man zshmodule
# man zshcontrib
