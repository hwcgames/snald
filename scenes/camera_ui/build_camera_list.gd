extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var cameras = get_tree().get_nodes_in_group("camera")
	cameras.sort_custom(self, "compare_camera")
	for camera in cameras:
		var button = Button.new()
		button.text = camera.properties["name"]
		add_child(button)
		button.connect("button_down", $"../../TabletScreenBase/CameraViewport", "apply_camera", [camera])
	pass # Replace with function body.

func compare_camera(a,b):
	var a_ = a.properties["camera_id"]
	var b_ = b.properties["camera_id"]
	return a_.casecmp_to(b_) == -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
