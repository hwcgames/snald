#!/bin/bash
if [ -z "$SNALD_TARGET" ]; then
	export SNALD_TARGET=$(uname)
fi

export SNALD_TARGET=${SNALD_TARGET,,}
export SNALD_TARGET=${SNALD_TARGET/darwin/mac}

# Compile intro story map
deno run --allow-read --allow-write=maps/intro-story-concat.map update_intro_story.js

# Create destination
export BUILD_DIR=./build/$SNALD_TARGET
mkdir -p $BUILD_DIR
export NAME="snald"
# Determine godot output profile
if [ "$SNALD_TARGET" == "mac" ]; then
	export GODOT_PROFILE="MacOSX"
	export EXTENSION="app"
elif [ "$SNALD_TARGET" == "windows" ]; then
	export GODOT_PROFILE="WindowsDesktop"
	export EXTENSION="exe"
elif [ "$SNALD_TARGET" == "web" ]; then
	export GODOT_PROFILE="HTML5"
	export EXTENSION="html"
	export NAME="index"
else
	export GODOT_PROFILE="Linux/X11"
	export EXTENSION="run"
fi
# Run godot build
./godot --no-window --export "$GODOT_PROFILE" $BUILD_DIR/$NAME.$EXTENSION
# Copy licensing
cp LICENSE ATTRIBUTION $BUILD_DIR
if [[ ! $SNALD_TARGET == "web" ]]; then
	# Create the maps directory and copy the maps
	mkdir -p $BUILD_DIR/maps
	cp maps/*.map $BUILD_DIR/maps
	# Determine the library extension 
	if [ "$SNALD_TARGET" == "mac" ]; then
		export EXTENSION="dylib"
	elif [ "$SNALD_TARGET" == "windows" ]; then
		export EXTENSION="dll"
	else
		export EXTENSION="so"
	fi
	find addons -name *.$EXTENSION -exec cp {} $BUILD_DIR \;
fi
echo "DONE!"