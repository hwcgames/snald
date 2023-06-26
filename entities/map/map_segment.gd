extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("map_segment")
	pass # Replace with function body.


func gen_2d_polygon():
	var children = get_children()
	var shapes = []
	for i in children:
		if i is MeshInstance:
			var vertices = PoolVector2Array([]);
			var origin = i.global_transform.origin
			var origin_2d = Vector2(origin.x, origin.z)
			var mesh = i.mesh
			var mdt = MeshDataTool.new()
			mdt.create_from_surface(mesh, 0)
			for vi in range(mdt.get_vertex_count()):
				var v = mdt.get_vertex(vi)
				var vertex = Vector2(v.x, v.z)
				if not vertex in vertices:
					vertices.push_back(vertex + origin_2d)
				pass
			shapes.push_back(Geometry.convex_hull_2d(vertices))
	var shape = PoolVector2Array([])
	for i in shapes:
		if len(shape) == 0:
			shape = i
		else:
			shape = Geometry.merge_polygons_2d(shape, i)
	return shape
	pass
