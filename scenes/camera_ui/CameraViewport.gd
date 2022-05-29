extends TextureRect

export var tweeny_boye_path: NodePath
onready var tween: Tween = get_node(tweeny_boye_path)
export var filter_path: NodePath
onready var filter: Control = get_node(filter_path)
export var sfx_path: NodePath
onready var sfx: AudioStreamPlayer = get_node(sfx_path)

var last_camera_id: String
var last_camera_room: String
var last_camera: Spatial

func _process(_delta):
	var p = get_parent()
	p.size = p.get_parent().rect_size

func apply_camera(camera_node):
	var _drop = tween.remove_all()
	var easing = 1
	var transition = 2
	_drop = tween.interpolate_method(filter, "put_aberration", 0.3, 0.0001, 1.0, transition, easing)
	_drop = tween.interpolate_method(filter, "put_warp", 1, 0, 1.0, transition, easing)
	_drop = tween.interpolate_method(filter, "put_roll_size", 1, 16, 1.0, transition, easing)
	_drop = tween.interpolate_method(filter, "put_distort", 2, 0.01, 1.0, transition, easing)
	_drop = tween.interpolate_method(filter, "put_noise_op", 1, 0.02, 1.0, transition, easing)
	_drop = tween.start()
	sfx.play()
	_ready()
	if last_camera_id:
		$"/root/EventMan".circuit_off("camera."+last_camera_id)
		$"/root/EventMan".circuit_off("camera."+last_camera_room)
		last_camera.viewed = false
	last_camera = camera_node
	last_camera.viewed = true
	last_camera_id = camera_node.properties["camera_id"]
	last_camera_room = camera_node.properties["room"]
	$"/root/EventMan".circuit_on("camera."+last_camera_id)
	$"/root/EventMan".circuit_on("camera."+last_camera_room)
	var viewport: Viewport = camera_node.get_node("Viewport")
	camera_node.get_node("Viewport").size = $"../../".get_global_rect().size
	self.texture = viewport.get_texture()
	self.texture.viewport_path = viewport.get_path()

var mouse_inside = false

func _input(event):
	if last_camera_id and mouse_inside:
		if event is InputEventMouseButton:
			var offset = get_global_rect().position
			event.position -= offset
			var factor = last_camera.get_node("Viewport").size / get_global_rect().size
			event.position *= factor
		last_camera.get_node("Viewport").unhandled_input(event)

func _mouse_entered():
	mouse_inside = true

func _mouse_exited():
	mouse_inside = false
