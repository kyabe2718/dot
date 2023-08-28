#! /usr/bin/env bash
set -eu

tmux set-option -g status-interval 15 # update rate of the status line

tmux set-option -g status-keys vi
tmux set-option -g status-bg black
tmux set-option -g status-fg white

tmux set-option -g status-left-length 80
tmux set-option -g status-left \
"#[fg=green]Host: #[default]#{host} \
Session: #[fg=green]#{session_name} \
#[fg=yellow]#{window_index} \
#[fg=cyan]#{pane_index}"

tmux set-option -g status-right-length 80
tmux set-option -g status-right \
"Network: #{net_speed} \
#[default]CPU: #{cpu_fg_color}#{cpu_percentage} \
#[default]RAM: #{ram_fg_color}#{ram_percentage} \
#[bg=black,fg=cyan][%Y-%m-%d %H:%M]"

tmux set-option -g status-justify absolute-centre # ウィンドウリストの位置を中心寄せにする
tmux set-option -g status-position top # ステータスバーを上部に表示する
tmux set-option -g monitor-activity on
tmux set-option -g visual-activity on

