#!/bin/bash

DECORATIONS=$(find $(realpath $(dirname $0)) -name \*.tscn -printf "%f\n" | xargs -I '{}' -n 1 basename '{}' .tscn)

echo "$DECORATIONS" > /tmp/snald-all-decorations

USED=$(
	cat $(realpath $(dirname $0))/../maps/default.map | \
	sed 's/^M/ /' | \
	grep -Pzoi '"classname" "Decoration"[^}]*"id" "([^"]*)"' | \
	grep -ao '"id" "[^"]*"' | \
	cut -d ' ' -f 2 | \
	grep -Po '[^"]*'
)

echo "$USED" > /tmp/snald-used-decorations

grep -f /tmp/snald-used-decorations -v /tmp/snald-all-decorations