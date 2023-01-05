extends BaseJumpscare

func _ready():
	$AnimationPlayer.play("blood")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finished", true)
