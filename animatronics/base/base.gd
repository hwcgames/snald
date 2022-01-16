extends Spatial

class_name AnimatronicBase

export var id = "base"
export var state = 0
export var room = ""
export var difficulty = 10
onready var animation_player: AnimationPlayer = $AnimationPlayer
var last_state = 0

func difficulty_offset():
	return 0

func state_machine():
	return 0

func animatronic_tick():
	$MovementTimer.start()
	var random = floor(rand_range(1,21))
	if difficulty + difficulty_offset() >= random:
		assume_state(state_machine())

func _ready():
	assume_state(0)
	$MovementTimer.connect("timeout", self, "animatronic_tick")
	$MovementTimer.start()

func assume_state(new_state: int):
	last_state = state
	var target = get_node_for_state(new_state)
	global_transform.origin = target.global_transform.origin
	rotation_degrees.y = target.get_angle()
	animation_player.play(target.get_animation())
	if new_state != state:
		$"/root/EventMan".circuit_off(id + "." + str(state))
		$"/root/EventMan".circuit_on(id + "." + str(new_state))
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
