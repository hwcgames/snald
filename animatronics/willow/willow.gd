extends AnimatronicBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monitor_world = $display_on_monitor
var visible_states = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimationPlayer
	add_to_group("display_on_monitor")
	connect("change_state", self, "new_state")
	pass
#connect to the circuits which track if  the player is looking at the monitor

func new_state(id: int):
	if id in visible_states:
		show()
	else:
		hide()

#func _process(delta):
#	pass
