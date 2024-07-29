#!/bin/bash

# Get the list of all windows in the current session
windows=$(tmux list-windows -F '#{window_index}')

# Record the index of the current window where the script is executed
current_window=$(tmux display-message -p '#I')

for win in $windows; do
    tmux select-window -t "$win"
    sleep 0.2

    # Resize the current window to maximum size
    tmux resize-window -A

    # Get the list of all panes in the current window
    # panes=$(tmux list-panes -F '#{pane_id}')

    # for pane in $panes; do
    #     tmux select-pane -t "$pane"
    #     tmux resize-pane -Z  # Toggle zoom for the current pane
    # done
done

# Switch back to the original window where the script started
tmux select-window -t "$current_window"
