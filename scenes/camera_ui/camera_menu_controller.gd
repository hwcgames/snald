extends Panel

onready var camera_viewport = get_parent().get_node("TabletScreenBase/ViewportContainer/Viewport/CameraViewport")
onready var camera_list_parent = $"VBoxContainer/ScrollContainer2/CameraListParent"


# Called when the node enters the scene tree for the first time.
func _ready():
	populate_cameras("")
	camera_viewport.connect("camera_change", self, "populate_cameras")
	pass # Replace with function body.

onready var cameras = get_tree().get_nodes_in_group("camera")
var current_index = -1

func populate_cameras(selected: String):
	if camera_list_parent.get_child_count() == 0:
		# SET UP CAMERAS
		for i in range(len(cameras)):
			var camera = cameras[i] as SnaldCamera;
			var id = camera.properties["camera_id"]
			var button: Button = Button.new()
			button.text = camera.properties["name"]
			button.editor_description = id
			button.connect("pressed", camera_viewport, "apply_camera", [camera])
			button.focus_mode = Control.FOCUS_ALL
			camera_list_parent.add_child(button)
			if id == selected:
				button.text = "> " + button.text + " <"
				current_index = i
				button.grab_focus()
				button.release_focus()
	else:
		for button in camera_list_parent.get_children():
			var camera
			for known_camera in cameras:
				if known_camera.properties["camera_id"] == button.editor_description:
					camera = known_camera
			var id = camera.properties["camera_id"]
			button.text = camera.properties["name"]
			if id == selected:
				button.text = "> " + button.text + " <"
				current_index = cameras.find(camera)
				button.grab_focus()
				button.release_focus()
	pass

func _physics_process(_delta):
	if !EventMan.circuit("player_camera_pad"):
		return
	if Input.is_action_just_pressed("ui_accept"):
		current_index += 1
		if current_index >= len(cameras):
			current_index = 0
		camera_viewport.apply_camera(cameras[current_index])
	if Input.is_action_just_pressed("ui_cancel"):
		current_index -= 1
		if current_index < 0:
			current_index = len(cameras) - 1
		camera_viewport.apply_camera(cameras[current_index])
