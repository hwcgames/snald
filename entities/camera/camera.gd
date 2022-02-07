extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera: Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("camera")
	yield(get_parent(), "build_complete")
	camera = $Camera
	remove_child(camera)
	$Viewport.add_child(camera)
	rotation_degrees.x = properties["elevation"] if "elevation" in properties else -20
	rotation_degrees.y = 180 + properties["angle"] if "angle" in properties else 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if camera:
		camera.global_transform = global_transform
#	pass
