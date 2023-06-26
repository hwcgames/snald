extends BaseJumpscare


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$lucas/AnimationPlayer.play("door_jumpscare")
	yield($lucas/AnimationPlayer,"animation_finished")
	emit_signal("finished")
	pass # Replace with function body.
