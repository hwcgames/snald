extends Spatial

class_name BaseJumpscare

signal finished

export var kill_player = true
# If this is false, the jumpscare will spawn in the player's starting position and angle.
export var relative = true
# Just a pointer to the player for funkiness
var player: Player
