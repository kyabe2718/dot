#! /usr/bin/env zsh

# function ssh(){
#     if [ -z ${DOTFILES_HOME:+} ]; then
#         DOTFILES_HOME=$(cd $(dirname $(readlink -f $0))/..; pwd -P)
#     fi
#     tmux pipe-pane "/usr/bin/zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh --listen"
#     sleep 1
#     /usr/bin/ssh $@
#     tmux pipe-pane && tmux display-message "ssh exited"
#     # TMUX_REMOTE_PORT=9090 /usr/bin/ssh -R ${TMUX_REMOTE_PORT}:localhost:${TMUX_REMOTE_PORT} $@
# }

if [[ "$1" == "" ]] && [[ -n "$TMUX" ]]; then

    # tmux set-option -g focus-events on
    # # 移動したpaneがsshを実行していたら、prefixを切り替える
    # is_ssh="ps -o state -o comm= -t ${pane_tty} | grep -iqE '^[^TXZ ]+ +(\S+\/)?ssh$'"
    # tmux set-hook -g pane-focus-in "run \
    #   \"($is_ssh && (tmux set-option -g prefix C-a; tmux unbind-key C-b)) \
    #   || (tmux set-option -g prefix C-a; tmux unbind-key C-b)\""

    # tmux bind-key h run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d left "
    # tmux bind-key j run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d down "
    # tmux bind-key k run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d up   "
    # tmux bind-key l run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d right"

    # tmux bind-key h run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d left  -p 9090 -l 9090"
    # tmux bind-key j run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d down  -p 9090 -l 9090"
    # tmux bind-key k run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d up    -p 9090 -l 9090"
    # tmux bind-key l run "/usr/bin/env zsh ${DOTFILES_HOME}/bin/tmux_select_pane.sh -d right -p 9090 -l 9090"

fi
