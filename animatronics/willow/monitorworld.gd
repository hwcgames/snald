extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var root = $"../../"
onready var player: AnimationPlayer = $wolo/AnimationPlayer
onready var parent_player: AnimationPlayer = $"../../wolo/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().connect("change_state", self, "new_state")
	pass # Replace with function body.

func new_state(state: int):
	player.play(parent_player.current_animation)
	if root.state in root.visible_states:
		hide()
	else:
		show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
