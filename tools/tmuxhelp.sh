#!/bin/bash

cat << "_EOF"

RE-ARRANGE PANE ORDER:
bind-key    -T prefix       {                 swap-pane -U
bind-key    -T prefix       }                 swap-pane -D

bind-key    -T prefix       q                 display-panes
bind-key    -T prefix       !                 break-pane

SPLIT WINDOW:
bind-key    -T prefix       -                 split-window -v
bind-key    -T prefix       |                 split-window -h

For tmux-resurrect:
bind-key    -T prefix       R                 run-shell /home/virl/.tmux/plugins/tmux-resurrect/scripts/restore.sh
bind-key    -T prefix       S                 run-shell /home/virl/.tmux/plugins/tmux-resurrect/scripts/save.sh
bind-key    -T prefix       U                 run-shell /home/virl/.tmux/plugins/tpm/bindings/update_plugins

_EOF
