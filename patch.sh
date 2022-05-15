#!/bin/bash
# This script generates a Godot .pck based on the git diff between two commits.

FROM=$1
TO=$2

FILES=$(git diff --name-only $FROM $TO)

echo "Generating patch for $FROM -> $TO"
echo "Files:"
echo $FILES

echo "Checking out goal commit..."
git checkout $TO
echo "Packing all differing files into a .pck..."
mkdir -p "build/diff"
touch build/diff/.gdignore
for i in $FILES; do
		zip build/diff/update.zip "$i"
done
