#!/bin/bash
mkdir -v -p build/linux
flatpak run org.godotengine.Godot -v --export "Linux/X11" build/linux/snald.x86_64
mkdir -p build/linux/{addons,maps}
cp -r maps/*.map build/linux/maps
mkdir -p build/linux/addons/qodot/bin
cp -r addons/qodot/bin/* build/linux/addons/qodot/bin