#!/bin/bash
##################################################
##################################################
# AUTHOR: Sean Tronsen
# Date: Thu Nov 23 16:29:44 MST 2023
#
# Idea inspired by similar tmux setups seen on
# YouTube.
##################################################
##################################################

# SOURCE LIBRARIES, CHECK DEPENDENCIES, SET BEHAVIOR

function session-connect() {
	if [ -z "$1" ]; then error "no argument provided"; fi
	if [ -z "$TMUX" ]; then
		tmux attach-session -t "$1"
	else
		tmux switch-client -t "$1"
	fi
}

set -e
source "$(dirname $(realpath ${BASH_SOURCE[0]}))/lib.bash"
binary_dependency_check fzf tmux >/dev/null

# SELECT DIRECTORY FOR SESSION
COMMON_DIRS="$(echo $HOME/{,.config,projects,homelab,Documents,Desktop,Downloads})"
SESSION_PATH=$(cat <(fd -d 1 -t d . $COMMON_DIRS) <(echo $COMMON_DIRS | sed 's/ /\n/g') | fzf)
if [ -z "$SESSION_PATH" ]; then
	error "a selection was not made"
fi
SESSION_NAME=$(basename $SESSION_PATH | sed 's/\./_/g')

# SESSION SPAWN
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
	tmux new-session -s "$SESSION_NAME" -c "$SESSION_PATH" -d
fi

# SESSION CONNECT
session-connect "$SESSION_NAME"
