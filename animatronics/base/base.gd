extends Spatial
class_name AnimatronicBase

export var id = "base"
export var state = -1
export var room = ""
export var difficulty = 10
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var model = get_node(id)
onready var bean = get_node("MeshInstance")
var last_state = 0

signal change_state(new_state)

func difficulty_offset():
	return 0

func state_machine():
	return 0

func animatronic_tick():
	if EventMan.pause:
		return
	var random = floor(rand_range(1,26))
	if difficulty + difficulty_offset() >= random:
		var s = state_machine()
		if s is GDScriptFunctionState:
			s = yield(s, "completed")
		if not s == -1:
			assume_state(s)
	$MovementTimer.start()

func _ready():
	assume_state(0)
	var _drop = $MovementTimer.connect("timeout", self, "animatronic_tick")
	$MovementTimer.start()

func assume_state(new_state: int):
	last_state = state
	var target = get_node_for_state(new_state)
	global_transform.origin = target.global_transform.origin
	rotation_degrees.y = target.get_angle()
	if "tpose" in animation_player.get_animation_list():
		animation_player.play("tpose")
	animation_player.play(target.get_animation())
	if new_state != state:
		$"/root/EventMan".circuit_off(id + "." + str(state))
		$"/root/EventMan".circuit_on(id + "." + str(new_state))
	if room != target.get_room():
		$"/root/EventMan".circuit_off(id + "." + room)
		$"/root/EventMan".circuit_on(id + "." + target.get_room())
	self.state = new_state
	room = target.get_room()
	emit_signal("change_state", new_state)
	if EventMan.funny_mode():
		model.hide()
		bean.show()

func glide_to_state(goal=0, duration=1.0, trans_type=0, ease_type=2, delay=0.0):
	var current_position = global_transform.origin
	var goal_position = get_node_for_state(goal).global_transform.origin
	var angle = Vector2(current_position.x, current_position.y).angle_to(Vector2(goal_position.x, goal_position.y))
	rotation_degrees.y = angle
	var t = Tween.new()
	add_child(t)
	t.interpolate_property(
		self,
		"global_transform:origin",
		current_position,
		goal_position,
		duration,
		trans_type,
		ease_type,
		delay
	)
	t.start()
	yield(t, "tween_completed")
	t.remove_and_skip()
	assume_state(goal)

func get_node_for_state(tgt_state: int):
	var all = get_nodes_for_state(tgt_state)
	var index = floor(rand_range(0, len(all)))
	return all[index]

func get_nodes_for_state(tgt_state: int):
	var all = get_nodes_for_me()
	var relevant = []
	for i in all:
		if i.get_state() == tgt_state:
			relevant.push_front(i)
	return relevant

func get_nodes_for_me():
	var all = get_tree().get_nodes_in_group("AnimatronicPosition")
	var relevant = []
	for i in all:
		if i.get_animatronic() == id:
			relevant.push_front(i)
	return relevant
