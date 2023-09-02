#! /usr/bin/env bash

# "-o comm= " means no column header
# "-o state= " means print process state
#   T: stopped by job control signal (e.g., stopped by C-z)
#   X: dead
#   Z: zombie process)
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
| grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
is_ssh="ps -o state= -o comm= -t '#{pane_tty}' \
| grep -iqE '^[^TXZ ]+ +(\\S+\\/)?ssh$'"

# :SmartWinCmdは端のwindowから更に移動しようとしたら、tmux select-paneを呼ぶ

tmux bind-key h if-shell "$is_vim" "send-key \":SmartWinCmd h\n\"" "select-pane -L"
tmux bind-key j if-shell "$is_vim" "send-key \":SmartWinCmd j\n\"" "select-pane -D"
tmux bind-key k if-shell "$is_vim" "send-key \":SmartWinCmd k\n\"" "select-pane -U"
tmux bind-key l if-shell "$is_vim" "send-key \":SmartWinCmd l\n\"" "select-pane -R"

tmux bind-key -Troot  C-w if-shell "$is_vim" "send-key C-w" "switch-client -Tctrlw"
tmux bind-key -Tctrlw h   "select-pane -L"
tmux bind-key -Tctrlw j   "select-pane -D"
tmux bind-key -Tctrlw k   "select-pane -U"
tmux bind-key -Tctrlw l   "select-pane -L"

