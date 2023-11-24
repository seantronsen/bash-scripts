#!/bin/bash
SESSION="server-status"

tmux -2 new-session -d -s $SESSION
tmux new-window -t $SESSION:1 -n "server-status"
tmux split
tmux split -h
tmux select-pane -t 2
tmux resize-pane -L 9
tmux resize-pane -U 5
tmux send-keys "watch -n 1 nvidia-smi" C-m
tmux select-pane -t 1
tmux send-keys "htop" C-m
tmux select-pane -t 0
tmux split
tmux select-pane -t 1
tmux split -h
tmux select-pane -t 2
tmux send-keys "watch -n 600 speedtest" C-m
tmux select-pane -t 1
tmux split
tmux select-pane -t 1
tmux send-keys "watch -n 1 df -h" C-m
tmux select-pane -t 2
tmux resize-pane -U 3
tmux send-keys "watch -n 1 expressvpn status" C-m
tmux select-pane -t 0
tmux split -h
tmux select-pane -t 1
tmux send-keys "watch -n 1 w" C-m
tmux select-pane -t 0
tmux send-keys "watch -n 1 sensors" C-m
tmux -2 attach-session -t $SESSION
