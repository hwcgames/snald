extends QodotEntity

func _ready():
	yield(get_parent(), "build_complete")
	if not "id" in properties:
		print("No decoration id set")
		return
	var scene: PackedScene = load("res://decorations/%s.tscn" % properties["id"])
	var inst: Spatial = scene.instance();
	for key in properties.keys():
		inst.set_meta(key, properties[key])
	if "rotation" in properties:
		rotation_degrees.y = float(properties["rotation"])
	add_child(inst)
