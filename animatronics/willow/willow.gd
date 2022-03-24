extends AnimatronicBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monitor_world = $display_on_monitor

signal update_state;

# Called when the node enters the scene tree for the first time.
func _ready():
#	animation_player = $
	add_to_group("display_on_monitor")
	pass
#connect to the circuits which track if  the player is looking at the monitor

func state_machine(): 
	pass

#func _process(delta):
#	pass
