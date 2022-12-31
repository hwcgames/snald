extends BaseJumpscare

func _ready():
	EventMan.pause = true
	$AnimationPlayer.play("glitch")
	yield($AnimationPlayer, "animation_finished")
	EventMan.pause = false
	emit_signal("finished")
	pass
