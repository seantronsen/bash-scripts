#!/bin/bash

set -e
LIB_NAME="bash-common-lib"

# PULL REQUIRED LIBRARIES
if [ ! -d "$LIB_NAME" ] || [ "$(ls "$LIB_NAME" | wc -l | grep -oE '\d+')" == "0" ]; then
	git submodule init
	git submodule update
fi

source lib.bash
add-user-bin

files="$(ls -a *.bash)"
for x in ${files[@]}; do
	if [ ! "$x" == "lib.bash" ] && [ ! "$x" == "install.bash" ]; then
		echo "issue item: $x"

		# removed parameter expansion due to issues on BSD Darwin
		link_name="$(sed 's/.bash//' <(echo "$x"))"
		link_path="$(realpath "$x")"
		(
			info "installing '$x' as $link_name"
			cd "$USER_BIN"
			ln -vis "$link_path" "$link_name"
			chmod -v u+x "$link_name"
		)
	fi
done
