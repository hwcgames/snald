extends BaseJumpscare

func _ready():
	$dog/AnimationPlayer.play("Jumpscare")
	yield($dog/AnimationPlayer, "animation_finished")
	emit_signal("finished")
	pass # Replace with function body.
