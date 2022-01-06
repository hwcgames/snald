extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	var transform = $"Camera".global_transform;
	$Viewport.add_child($"Camera")
	$"Viewport/Camera".global_transform = transform
	$"Viewport/Camera".rotation_degrees.x = properties["elevation"] if "elevation" in properties else -20
	$"Viewport/Camera".rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
