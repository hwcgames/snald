extends Control

onready var fullscreen = OS.window_fullscreen
onready var size = get_viewport().size

func _ready():
	OS.window_fullscreen = true
	get_viewport().size = OS.get_screen_size()
	$AnimationPlayer.play("go")
	yield($AnimationPlayer, "animation_finished")
	pass # Replace with function body.


func _on_ExitDeadButton_pressed():
	get_viewport().size = size
	OS.window_fullscreen = fullscreen
	EventMan.return_to_title()
	pass # Replace with function body.
