extends Control

func _ready():
	$AnimationPlayer.play("go")
	yield($AnimationPlayer, "animation_finished")
	pass # Replace with function body.
