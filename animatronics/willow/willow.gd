extends AnimatronicBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#connect to the circuits which track if  the player is looking at the monitor

func state_machine(): 
	#if monitor circuit thingy = true and camera = false:
		#return state
	else:
		return state + 1
#func _process(delta):
#	pass
