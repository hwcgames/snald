extends AnimatronicBase

func state_machine():
	return state + 1 if state < 2 else 0
