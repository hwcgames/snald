extends TextureRect

var last_camera_id: String
var last_camera_room: String
var last_camera: Spatial

func apply_camera(camera_node):
	if last_camera_id:
		$"/root/EventMan".circuit_off("camera."+last_camera_id)
		$"/root/EventMan".circuit_off("camera."+last_camera_room)
	last_camera = camera_node
	last_camera_id = camera_node.properties["camera_id"]
	last_camera_room = camera_node.properties["room"]
	$"/root/EventMan".circuit_on("camera."+last_camera_id)
	$"/root/EventMan".circuit_on("camera."+last_camera_room)
	var viewport: Viewport = camera_node.get_node("Viewport")
	self.texture = viewport.get_texture()

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
