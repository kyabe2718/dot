#! /usr/bin/env bash
set -eu

# ---------- copy mode ----------
tmux bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
if type xsel > /dev/null 2>&1; then
    tmux bind-key -Tcopy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel -pi && xsel -po | xsel -bi" # xselのprimary及びclipboardに保存
    # zshの方でpasteを割り当ててるので不要
    # tmux bind-key p run "xsel -bo | tmux load-buffer - ; tmux paste-buffer" # xselのclipboard selectionからload&pasteする
else
    tmux display-message "xsel is not installed!!"
    tmux bind-key -Tcopy-mode-vi y send-keys -X copy-selection
fi


