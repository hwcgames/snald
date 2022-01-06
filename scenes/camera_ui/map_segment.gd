extends Node2D

var room_id: String = "set-me"

var aabb: Rect2 = Rect2(Vector2(INF, INF), Vector2(-INF, -INF))

# Called when the node enters the scene tree for the first time.
func _ready():
	for s in get_tree().get_nodes_in_group("map_segment"):
		if s.properties["room"] == room_id:
			var polygon = s.gen_2d_polygon()
			for point in polygon:
				aabb.position.x = min(aabb.position.x, point.x)
				aabb.position.y = min(aabb.position.y, point.y)
				aabb.size.x = max(aabb.position.x + aabb.size.x, point.x) - aabb.position.x
				aabb.size.y = max(aabb.position.y + aabb.size.y, point.y) - aabb.position.y
			var polygon2d = Polygon2D.new()
			polygon2d.polygon = polygon
			match s.properties["type"]:
				"room":
					polygon2d.color = Color(1,1,1,.75)
				"vent":
					polygon2d.color = Color(.75,.75,.75,.5)
				"outdoors":
					polygon2d.color = Color(.75,.75,.75,0)
				"door":
					polygon2d.color = Color(0,0,0,1)
			add_child(polygon2d)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
