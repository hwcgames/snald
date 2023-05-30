extends Control

onready var fullscreen = OS.window_fullscreen
onready var size = get_viewport().size

signal finished(quit)

func _ready():
	OS.window_fullscreen = true
	get_viewport().size = OS.get_screen_size()
	$AnimationPlayer.play("go")
	yield($AnimationPlayer, "animation_finished")
	pass # Replace with function body.


func _on_ExitDeadButton_pressed():
	get_viewport().size = size
	OS.window_fullscreen = fullscreen
	emit_signal("finished", true)
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_R:
			_on_QuickResetButton_pressed()

func _on_QuickResetButton_pressed():
	get_viewport().size = size
	OS.window_fullscreen = fullscreen
	emit_signal("finished", false)
	pass # Replace with function body.
