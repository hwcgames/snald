extends AnimatronicBase
class_name Randy

func state_machine():
	var states = []
	for i in get_nodes_for_me():
		if not i.get_state() in states:
			states.push_front(i.get_state())
	var index = floor(rand_range(0, len(states)))
	var new_state = states[index]
	print("Randy moves! ", new_state)
	return new_state
