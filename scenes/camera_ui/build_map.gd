extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAP_SEGMENT = preload("res://scenes/camera_ui/map_segment.tscn")
var CAMERA_MARGIN = 5

# Called when the node enters the scene tree for the first time.
func _ready():
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
	average_center /= len(rooms)
	var width = top_right.x - bottom_left.x
	var height = top_right.y - bottom_left.y
	var camera = Camera2D.new()
	add_child(camera)
	camera.current = true
	camera.transform.origin = average_center
	print(width,' ',height)
	width /= self.size.x
	height /= self.size.y
	var zoom = max(width, height)
	camera.zoom = Vector2(1,1) * zoom
	print(width,' ',height)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
