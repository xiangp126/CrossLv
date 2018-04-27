#!/bin/bash

cat << "_EOF"
------------------------------------------------------------
-                RE-ARRANGE PANE ORDER                     -
------------------------------------------------------------
bind-key    -T prefix       {                 swap-pane -U
bind-key    -T prefix       }                 swap-pane -D

------------------------------------------------------------
-              SWAP AND MOVE FOR WINDOW                    -
------------------------------------------------------------
:swap-window [-s src-client] -t dst-window  # swap window src with dst
:swap-window -t dst-window                  # swap current window with dst
:move-window [-s src-window] -t dst-window  # move current window to No.1
:move-window -t [dst-client]                # move current window to dst-client

:attach-session -c /usr/local/     # set new pane default path
:attach-session -c "#{pane_current_path}"

------------------------------------------------------------
-          JOIN-PANE AND BREAK PANE TO WINDOW              -
------------------------------------------------------------
bind-key    -T prefix       q                 display-pane order numbers
bind-key    -T prefix       !                 break-pane into a new window
:join-pane -s [session_name]:[window].[pane]  # join the pane to current window
:join-pane -s virl:2.1

------------------------------------------------------------
-                      MAXIMUM PANE                        -
------------------------------------------------------------
bind-key    -T prefix       x                 close current pane
bind-key    -T prefix       X                 toggle maximum pane

------------------------------------------------------------
-                       SPLIT WINDOW                       -
------------------------------------------------------------
bind-key    -T prefix       -                 split-window -v
bind-key    -T prefix       |                 split-window -h

------------------------------------------------------------
-                    FOR TMUX-RESURRECT                    -
------------------------------------------------------------
bind-key    -T prefix       S       run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
bind-key    -T prefix       R       run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
bind-key    -T prefix       U       run-shell ~/.tmux/plugins/tpm/bindings/update_plugins
------------------------------------------------------------
_EOF
