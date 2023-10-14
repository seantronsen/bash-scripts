#!/bin/bash

set -e
source lib.bash
add-user-bin

files="$(ls -a *.bash)"
for x in ${files[@]}; do
	if [ ! "$x" == "lib.bash" ] && [ ! "$x" == "install.bash" ]; then
		link_name="${x::-5}"
		link_path="$(realpath "$x")"
		(
			echo "installing '$x' as $link_name"
			cd "$USER_BIN"
			ln -vis "$link_path" "$link_name"
			chmod u+x "$link_name"
		)
	fi
done
