#! /usr/bin/env bash

# "-o comm= " means no column header
# "-o state= " means print process state
#   T: stopped by job control signal (e.g., stopped by C-z)
#   X: dead
#   Z: zombie process)
# is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
# is_ssh="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?ssh$'"

# :SmartWinCmdは端のwindowから更に移動しようとしたら、tmux select-paneを呼ぶ
# tmux bind-key h run "($is_vim && tmux send-key C-w h) || tmux select-pane -L"
# tmux bind-key j run "($is_vim && tmux send-key C-w j) || tmux select-pane -D"
# tmux bind-key k run "($is_vim && tmux send-key C-w k) || tmux select-pane -U"
# tmux bind-key l run "($is_vim && tmux send-key C-w l) || tmux select-pane -R"
#
# tmux bind-key h run "($is_vim && tmux send-key C-w h) || ($is_ssh && (tmux send-prefix; tmux send-key h)) || tmux select-pane -L"
# tmux bind-key j run "($is_vim && tmux send-key C-w j) || ($is_ssh && (tmux send-prefix; tmux send-key j)) || tmux select-pane -D"
# tmux bind-key k run "($is_vim && tmux send-key C-w k) || ($is_ssh && (tmux send-prefix; tmux send-key k)) || tmux select-pane -U"
# tmux bind-key l run "($is_vim && tmux send-key C-w l) || ($is_ssh && (tmux send-prefix; tmux send-key l)) || tmux select-pane -R"

tmux bind-key -Troot  C-w if-shell "$is_vim" "send-key C-w" "switch-client -Tctrlw"
tmux bind-key -Tctrlw h   "select-pane -L"
tmux bind-key -Tctrlw j   "select-pane -D"
tmux bind-key -Tctrlw k   "select-pane -U"
tmux bind-key -Tctrlw l   "select-pane -L"

# ---------- ssh ----------
tmux set-option -g focus-events on
# 移動したpaneがsshを実行していたら、prefixを切り替える
# tmux set-hook -g pane-focus-in "run \
#   \"($is_ssh && (tmux set-option -g prefix C-a; tmux unbind-key C-b)) \
#   || (tmux set-option -g prefix C-a; tmux unbind-key C-b)\""

# tmux set-hook -g pane-focus-in "run \
#   \"($is_ssh && (tmux set-option -g prefix C-b; tmux unbind-key C-a)) \
#     || (tmux set-option -g prefix C-a; tmux unbind-key C-b)\""

