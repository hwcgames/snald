extends Button

signal pop

func _pressed():
	emit_signal("pop")
