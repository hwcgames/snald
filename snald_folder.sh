#!/bin/bash
# Generates a snald_folder.tres file.

echo "Path to your Trenchbroom game location? (Like /home/you/.TrenchBroom/games)"
read TBROOM_LOCATION

cat > snald_folder.tres << EOF
[gd_resource type="Resource" load_steps=5 format=2]

[ext_resource path="res://icon.png" type="Texture" id=2]
[ext_resource path="res://addons/qodot/src/resources/game-definitions/trenchbroom/trenchbroom_game_config_folder.gd" type="Script" id=3]
[ext_resource path="res://fgd.tres" type="Resource" id=4]
[ext_resource path="res://snald_file.tres" type="Resource" id=5]

[resource]
script = ExtResource( 3 )
export_file = false
trenchbroom_games_folder = "$TBROOM_LOCATION"
game_name = "$(basename $(pwd) | tr [a-z] [A-Z])"
icon = ExtResource( 2 )
game_config_file = ExtResource( 5 )
fgd_files = [ ExtResource( 4 ) ]
EOF