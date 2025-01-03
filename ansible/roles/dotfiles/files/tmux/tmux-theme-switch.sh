#!/bin/bash

if [ -f "$HOME/.light" ]; then
    tmux set-option -g status-fg colour0
    tmux set-option -g status-bg colour7
    tmux set-option -g window-status-current-style bg=colour3,fg=colour7
else
    tmux set-option -g status-fg colour15
    tmux set-option -g status-bg colour0
    tmux set-option -g window-status-current-style bg=colour3,fg=colour0
fi
