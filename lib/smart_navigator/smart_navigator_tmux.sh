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

# tmux bind-key -Troot C-w switch-client -Tnav
# tmux bind-key -Tnav h if-shell "$is_vim" "send-key C-w h" "select-pane -L"
# tmux bind-key -Tnav j if-shell "$is_vim" "send-key C-w j" "select-pane -D"
# tmux bind-key -Tnav k if-shell "$is_vim" "send-key C-w k" "select-pane -U"
# tmux bind-key -Tnav l if-shell "$is_vim" "send-key C-w l" "select-pane -R"
# tmux bind-key -Tnav C-w "send-key C-w l"

# tmux bind-key -Tnav h if-shell "$is_vim" "send-key \":wincmd h\n\"" "select-pane -L"
# tmux bind-key -Tnav j if-shell "$is_vim" "send-key \":wincmd j\n\"" "select-pane -D"
# tmux bind-key -Tnav k if-shell "$is_vim" "send-key \":wincmd k\n\"" "select-pane -U"
# tmux bind-key -Tnav l if-shell "$is_vim" "send-key \":wincmd l\n\"" "select-pane -R"

