extends Spatial

onready var circuit = get_meta("circuit")
export var pictures: PoolStringArray
export var weights: PoolRealArray

var textures = []

func _ready():
	EventMan.connect("on", self, "on")
	for path in pictures:
		textures.push_back(load(path))
	refresh()

func on(c: String):
	if c == circuit:
		refresh()

func refresh():
	var rng = rand_range(0, 1);
	var acc = 0;
	for index in range(len(weights)):
		acc += weights[index]
		if acc > rng:
			var mat = $MeshInstance.get_surface_material(0)
			mat.albedo_texture = textures[index]
			mat.normal_texture = textures[index]
			$MeshInstance.set_surface_material(0, mat)
			return
