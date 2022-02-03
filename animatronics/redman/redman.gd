extends AnimatronicBase
export var office_door_circuit = "office_door_toggle"

func state_machine():
	match state:
		0:
			var roll = randf()
			if roll < .5:
				return 1
			else:
				return 3
		2:
			var roll = randf()
			if roll <.66:
				return 6
			else:
				return 1
		3:
			var roll = randf()
			if roll <.66:
				return 4
			else:
				return 0
		6: 
			if (office_door_circuit in $"/root/EventMan".circuit_states) and ($"/root/EventMan".circuit_states[office_door_circuit]):
				$"/root/EventMan".jumpscare("redman", "door")
				return 0
			else:
				return 0
	var roll = randf()
	if roll <.66:
		return state + 1
	else:
		return state - 1
