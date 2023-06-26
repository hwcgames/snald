extends CanvasLayer

func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.pressed:
			get_parent().advance_cutscene()

var pressed_last_frame = false

func _physics_process(_delta):
	if Input.is_mouse_button_pressed(0) and not pressed_last_frame:
		get_parent().advance_cutscene()
		pressed_last_frame = true
	elif not Input.is_mouse_button_pressed(0):
		pressed_last_frame = false
