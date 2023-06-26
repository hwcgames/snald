extends BaseJumpscare

func _ready():
	$Kenzie/AnimationPlayer.play("punch")
	yield($Kenzie/AnimationPlayer, "animation_finished")
	emit_signal("finished")
	pass # Replace with function body.
