#!/bin/bash
################################################################################
################################################################################
# Author: Sean Tronsen
#
# Simple bash utility to reduce the verbosity required for port forwarding with
# `ssh` from the openssh package.
#
# The idea was to specify a series of arguments with:
# - $1: 		service port number for tunneling
# - $2-$n: 	node name via FQDN, ssh config name, or address
#
# More simply, specify the nodes to travel along and the port of the service to
# connect to. With successful execution, the port will be accessible locally as
# if it were on your own device.
################################################################################
################################################################################

source "$(dirname $(realpath ${BASH_SOURCE[0]}))/lib.bash"

set -e
SWITCHES=" -v -t "

if [ "$(($# < 2))" == "1" ]; then
	echo $(basename $0) '<port> <node> [<node> ...]'
	error "insufficent arguments"
fi

info "building tunnel command with verbose output"
PORT="$1"
shift
cli_args=($@)

command_str=""
for ((c = 0; c < $#; c++)); do
	current_node="${cli_args[$c]}"
	command_str="$command_str ssh $SWITCHES -L $PORT:localhost:$PORT $current_node"
done

info "command: $command_str"
eval "${command_str:1}" | while read -r line; do info "$line"; done
