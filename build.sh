#!/bin/bash
if [ -z "$SNALD_TARGET" ]; then
	export SNALD_TARGET=$(uname)
fi
which godot > /dev/null && export godot="godot" || export godot="flatpak run org.godotengine.Godot"

# Create destination
export BUILD_DIR=./build/$SNALD_TARGET
mkdir -p $BUILD_DIR
export NAME="snald"
# Determine godot output profile
if [ "$SNALD_TARGET" == "Darwin" ]; then
	export GODOT_PROFILE="Mac OSX"
	export EXTENSION="app"
elif [ "$SNALD_TARGET" == "Windows" ]; then
	export GODOT_PROFILE="Windows Desktop"
	export EXTENSION="exe"
elif [ "$SNALD_TARGET" == "Web" ]; then
	export GODOT_PROFILE="HTML5"
	export EXTENSION="html"
	export NAME="index"
else
	export GODOT_PROFILE="Linux/X11"
	export EXTENSION="run"
fi
# Run godot build
$godot --no-window --export "$GODOT_PROFILE" $BUILD_DIR/$NAME.$EXTENSION
# Copy licensing
CP LICENSE ATTRIBUTION $BUILD_DIR
if [[ ! $SNALD_TARGET == "Web" ]]; then
	# Create the maps directory and copy the maps
	mkdir -p $BUILD_DIR/maps
	cp maps/*.map $BUILD_DIR/maps
	# Determine the library extension 
	if [ "$SNALD_TARGET" == "Darwin" ]; then
		export EXTENSION="dylib"
	elif [ "$SNALD_TARGET" == "Windows" ]; then
		export EXTENSION="dll"
	else
		export EXTENSION="so"
	fi
	find addons -name *.$EXTENSION -exec cp {} $BUILD_DIR \;
fi
echo "DONE!"