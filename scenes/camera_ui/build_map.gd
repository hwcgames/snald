extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAP_SEGMENT = preload("res://scenes/camera_ui/map_segment.tscn")
var CAMERA = preload("res://scenes/camera_ui/camera.tscn")
var CAMERA_MARGIN = 5
var width: float
var height: float
var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "setup_camera")
	# BUILD ROOM GEOMETRY
	var rooms = PoolStringArray([])
	for i in get_tree().get_nodes_in_group("map_segment"):
		if not i.properties["room"] in rooms:
			rooms.push_back(i.properties["room"])
	var average_center = Vector2.ZERO
	var top_right = Vector2(-INF, -INF)
	var bottom_left = Vector2(INF, INF)
	for i in rooms:
		var segment = MAP_SEGMENT.instance()
		segment.room_id = i
		add_child(segment)
		var center = segment.aabb.position + (segment.aabb.size / 2)
		average_center += center
		top_right.x = max(top_right.x, center.x + CAMERA_MARGIN)
		top_right.y = max(top_right.y, center.y + CAMERA_MARGIN)
		bottom_left.x = min(bottom_left.x, center.x - CAMERA_MARGIN)
		bottom_left.y = min(bottom_left.y, center.y - CAMERA_MARGIN)
	# SET UP VIEWPOINT
	average_center /= len(rooms)
	camera = Camera2D.new()
	add_child(camera)
	camera.rotating = true
	camera.rotation_degrees = 90
	height = top_right.x - bottom_left.x
	width = top_right.y - bottom_left.y
	camera.current = true
	camera.transform.origin = average_center + Vector2(0, 10)
	print(width,' ',height)
	call_deferred("setup_camera")
	# SET UP CAMERAS
	for i in get_tree().get_nodes_in_group("camera"):
		var camera_icon = CAMERA.instance()
		camera_icon.camera_id = i.properties["camera_id"]
		camera_icon.rotation_degrees = 180 - i.properties["angle"]
		camera_icon.transform.origin = Vector2(i.transform.origin.x, i.transform.origin.z)
		camera_icon.scale = Vector2(1,1) * 0.1
		add_child(camera_icon)

func setup_camera():
	var rel_width = width / self.size.x
	var rel_height = height / self.size.y
	var zoom = max(rel_width, rel_height)
	camera.zoom = Vector2(1,1) * zoom * 1.2
	print(rel_width,' ',rel_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
