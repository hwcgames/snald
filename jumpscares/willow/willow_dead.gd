extends Control

func _ready():
	$AnimationPlayer.play("go")
	yield($AnimationPlayer, "animation_finished")
	EventMan.return_to_title()
	pass # Replace with function body.
