extends QodotEntity

var aabb: AABB
var player: Player
var circuit = "default"

func _ready():
	yield(get_parent(), "build_complete")
	circuit = properties["circuit"] if "circuit" in properties else circuit
	for node in get_tree().get_nodes_in_group("player"):
		if node is Player:
			player = node
			break
	# Remove all collision
	for child in get_children():
		if child is CollisionShape:
			child.queue_free()
	# Build aabb
	for i in get_children():
		if i is MeshInstance:
			var origin = i.global_transform.origin
			var mesh = i.mesh
			var mdt = MeshDataTool.new()
			mdt.create_from_surface(mesh, 0)
			for vi in range(mdt.get_vertex_count()):
				var vertex = mdt.get_vertex(vi)
				var point = vertex + origin
				if not aabb:
					aabb = AABB(point, Vector3.ZERO)
				else:
					aabb = aabb.expand(point)

func _physics_process(_delta):
	if not player:
		return
	var player_pos = player.global_transform.origin
	var desired_state = aabb.has_point(player_pos)
	if desired_state != EventMan.circuit(circuit):
		if desired_state:
			EventMan.circuit_on(circuit)
		else:
			EventMan.circuit_off(circuit)
