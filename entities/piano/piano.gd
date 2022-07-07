extends QodotEntity

const NUM_KEYS_BASE = 49

func _ready():
	add_to_group("piano")
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"]
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		var code = event.unicode
		var number = (code - NUM_KEYS_BASE) + 1
		if number < 1 or number > 8:
			return
		if event.pressed:
			EventMan.circuit_on(properties["piano_circuit_prefix"] + str(number))
		else:
			EventMan.circuit_off(properties["piano_circuit_prefix"] + str(number))
