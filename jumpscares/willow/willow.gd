extends BaseJumpscare

func _ready():
	$AnimationPlayer.play("glitch")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finished")
	pass
