extends Button

func _pressed():
	EventMan.circuit_off($"../LineEdit".text)
