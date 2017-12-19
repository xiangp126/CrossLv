#!/bin/bash

cat << "_EOF"

************************************************************
*                RE-ARRANGE PANE ORDER                     *
************************************************************
bind-key    -T prefix       {                 swap-pane -U
bind-key    -T prefix       }                 swap-pane -D

************************************************************
*          JOIN-PANE AND BREAK PANE TO WINDOW              *
************************************************************
bind-key    -T prefix       q                 display-panes
bind-key    -T prefix       !                 break-pane
:join-pane -s [session_name]:[window].[pane]  # join the pane to current window
:join-pane -s virl:2.1

************************************************************
*                      MAXIMUM PANE                        *
************************************************************
bind-key    -T prefix       x                 close current pane
bind-key    -T prefix       X                 toggle maximum pane

************************************************************
*                       SPLIT WINDOW                       *
************************************************************
bind-key    -T prefix       -                 split-window -v
bind-key    -T prefix       |                 split-window -h

************************************************************
*                    FOR TMUX-RESURRECT                    *
************************************************************
bind-key    -T prefix       S       run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
bind-key    -T prefix       R       run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
bind-key    -T prefix       U       run-shell ~/.tmux/plugins/tpm/bindings/update_plugins

 _                        _          _
| |_ _ __ ___  _   ___  _| |__   ___| |_ __
| __| '_ ` _ \| | | \ \/ / '_ \ / _ \ | '_ \
| |_| | | | | | |_| |>  <| | | |  __/ | |_) |
 \__|_| |_| |_|\__,_/_/\_\_| |_|\___|_| .__/
                                      |_|

_EOF
