extends Spatial

class_name AnimatronicBase

export var id = "base"
export var state = 0
export var room = ""
export var difficulty = 10

func state_machine():
	return 0

func animatronic_tick():
	var random = floor(rand_range(1,21))
	if difficulty >= random:
		assume_state(state_machine())

func _ready():
	assume_state(state)
	$"/root/EventMan".connect("animatronic_tick", self, "animatronic_tick")

func assume_state(new_state: int):
	var target = get_node_for_state(new_state)
	global_transform.origin = target.global_transform.origin
	rotation_degrees.y = target.get_angle()
	$AnimationPlayer.current_animation = target.get_animation()
	$"/root/EventMan".circuit_off(id + "." + state)
	$"/root/EventMan".circuit_off(id + "." + new_state)
	if room != target.get_room():
		$"/root/EventMan".circuit_off(id + "." + room)
		$"/root/EventMan".circuit_on(id + "." + target.get_room())
	self.state = new_state
	room = target.get_room()

func get_node_for_state(state: int):
	var all = get_nodes_for_state(state)
	var index = floor(rand_range(0, len(all)))
	return all[index]

func get_nodes_for_state(state: int):
	var all = get_nodes_for_me()
	var relevant = []
	for i in all:
		if i.get_state() == state:
			relevant.push_front(i)
	return relevant

func get_nodes_for_me():
	var all = get_tree().get_nodes_in_group("AnimatronicPosition")
	var relevant = []
	for i in all:
		if i.get_animatronic() == id:
			relevant.push_front(i)
	return relevant
