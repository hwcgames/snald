extends TextureRect

var last_camera_id: String
var last_camera_room: String
var last_camera: Spatial

func apply_camera(camera_node):
	if last_camera_id:
		$"/root/EventMan".circuit_off("camera."+last_camera_id)
		$"/root/EventMan".circuit_off("camera."+last_camera_room)
		last_camera.hide()
	last_camera = camera_node
	last_camera_id = camera_node.properties["camera_id"]
	last_camera_room = camera_node.properties["room"]
	$"/root/EventMan".circuit_on("camera."+last_camera_id)
	$"/root/EventMan".circuit_on("camera."+last_camera_room)
	last_camera.show()
	var viewport: Viewport = camera_node.get_node("Viewport")
	self.texture = viewport.get_texture()
