extends Button

export var frame_id: String
signal push(to)

func _pressed():
	emit_signal("push", frame_id)
