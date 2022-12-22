extends Control

var character: AnimatronicBase

onready var id_box: LineEdit = $"./LineEdit"
onready var state_box: SpinBox = $"./SpinBox"
onready var apply_button: Button = $"./ApplyState"
onready var tick_button: Button = $"./ForceTick"
onready var goto_button: Button = $"./Goto"

func _ready():
	id_box.connect("text_changed", self, "refresh")
	state_box.connect("value_changed", self, "refresh")
	apply_button.connect("pressed", self, "apply_state")
	tick_button.connect("pressed", self, "tick")
	goto_button.connect("pressed", self, "goto")
	refresh()

func refresh(_a = null):
	character = null
	for c in get_tree().get_nodes_in_group("animatronic"):
		if c.id == id_box.text:
			character = c
	apply_button.disabled = !(character && len(character.get_nodes_for_state(state_box.value)) > 0)
	tick_button.disabled = !character
	goto_button.disabled = !(character && len(character.get_nodes_for_state(state_box.value)) > 0)
	pass

func apply_state():
	character.assume_state(state_box.value)
	goto()
	pass

func tick():
	character.animatronic_tick()
	pass

func goto():
	var cam: Camera = $"/root/test/Camera";
	cam.transform.origin = character.transform.origin
	cam.translate_object_local(Vector3(0, 2, 4))
