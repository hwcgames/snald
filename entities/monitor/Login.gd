extends Control

const truth = [1,2,3,4]
var buffer = []
var mappings = []
onready var player_input_parent: HBoxContainer = $"%PlayerInputParent"
onready var truth_parent: HBoxContainer = $"%TruthParent"

signal success;

func _ready():
	EventMan.connect("on", self, "on")

func login():
	for child in truth_parent.get_children():
		child.queue_free()
	for child in player_input_parent.get_children():
		child.queue_free()
	buffer = []
	mappings = []
	var buttons_to_press = truth.slice(0, 3)
	while len(buttons_to_press) > 0:
		var index = floor(rand_range(0, len(buttons_to_press)))
		var value = buttons_to_press[index]
		buttons_to_press.remove(index)
		mappings.push_back(value)
		var label = Label.new()
		label.add_font_override('font', preload('./monitor_font.tres'))
		label.size_flags_horizontal = SIZE_EXPAND_FILL
		label.text = str(value)
		truth_parent.add_child(label)

func on(circuit: String):
	if len(mappings) == 0:
		return
	print(circuit)
	if circuit.ends_with('_not'):
		return
	if circuit.begins_with("monitor_button"):
		circuit = circuit.replace("monitor_button", "")
		var index = int(circuit)
		var value = mappings[index]
		buffer.push_back(value)
		var label = Label.new()
		label.text = str(value)
		label.add_font_override('font', preload('./monitor_font.tres'))
		player_input_parent.add_child(label)
		if buffer != truth.slice(0, len(buffer)-1):
			login()
		elif len(buffer) >= len(truth):
			mappings = []
			emit_signal("success")
