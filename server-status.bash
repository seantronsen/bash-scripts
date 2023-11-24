#!/bin/bash
SESSION="server-status"

if ! tmux has-session -t $SESSION >/dev/null; then
	# SPAWN SESSION
	tmux -2 new-session -s $SESSION -d

	# WINDOW FOR SENSORS & PROCESSES
	tmux rename-window -t "$SESSION:0" "processes/sensors"
	for _ in {1..2}; do tmux split-window -t "$SESSION:0"; done
	tmux send-keys -t "$SESSION:0.0" "htop" C-m
	tmux send-keys -t "$SESSION:0.1" "watch -n 0.1 nvidia-smi" C-m
	tmux send-keys -t "$SESSION:0.2" "watch -n 1 sensors" C-m
	tmux select-layout -t "$SESSION:0" even-vertical

	# DMESG TAIL
	tmux new-window -t $SESSION:1 -n "dmesg tail"
	tmux send-keys -t "$SESSION:1.0" "sudo dmesg --follow-new" C-m
	tmux select-layout -t "$SESSION:1" even-vertical

	# WINDOW FOR NETWORK & STORAGE
	tmux new-window -t $SESSION:2 -n "network/storage"
	tmux split-window -t "$SESSION:2"
	tmux send-keys -t "$SESSION:2.0" "watch -n 600 speedtest-rs" C-m
	tmux send-keys -t "$SESSION:2.1" "watch -n 1 df -h" C-m
	tmux select-layout -t "$SESSION:2" even-vertical

	# WINDOW FOR USERS
	tmux new-window -t $SESSION:3 -n "system users"
	tmux send-keys -t "$SESSION:3.0" "watch -n 0.1 w" C-m
	tmux select-layout -t "$SESSION:3" even-vertical
fi

# LAUNCH
if [ -z "$TMUX" ]; then
	tmux -2 attach-session -t $SESSION
else
	tmux -2 switch-client -t $SESSION
fi
