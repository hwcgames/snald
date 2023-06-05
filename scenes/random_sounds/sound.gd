extends AudioStreamPlayer3D
class_name SoundChoice

export var weight = 1.0

func _ready():
	EventMan.connect("on", self, "on")

func go():
	var rel = get_tree().get_nodes_in_group("player")[0].global_transform.origin
	global_transform.origin = rel + Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1))
	stop()
	play()
