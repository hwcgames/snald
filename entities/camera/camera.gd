extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("camera")
	yield(get_parent(), "build_complete")
	var camera = $Camera
	var transform = camera.global_transform;
	$Viewport.add_child(camera)
	camera.global_transform = transform
	camera.rotation_degrees.x = properties["elevation"] if "elevation" in properties else -20
	camera.rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
