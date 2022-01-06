extends QodotEntity

var CAMERA = preload("res://scenes/camera_ui/camera_ui.tscn")
onready var camera: Control = CAMERA.instance()

func _ready():
	yield(get_parent(), "build_complete")
	print("Set player angle to default")
	rotation_degrees.y = properties["angle"]
	print("Bringing camera UI into tree")
	add_child(camera)

func _process(delta):
	# Get mouse X
	var mouse_x = get_viewport().get_mouse_position().x / get_viewport().size.x
	# Check whether the camera is bounded
	var left_bounded = false
	var right_bounded = false
	for i in get_tree().get_nodes_in_group("PlayerCameraBounds"):
		if i.is_on_screen():
			if i.is_right:
				right_bounded = true
			else:
				left_bounded = true
	# Determine which direction to move
	var movement = 0.0
	if mouse_x < 0.1 and not left_bounded:
		movement += 1
	if mouse_x > 0.9 and not right_bounded:
		movement -= 1
	# Move
	rotation_degrees.y += movement * delta * (properties["speed"] if "speed" in properties else 30)
