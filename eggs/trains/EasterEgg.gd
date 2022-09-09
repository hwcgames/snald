extends StaticBody
class_name EasterEgg

signal got

func _ready():
	connect("input_event", self, "input")

func input(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and visible:
			clicked()

func clicked():
	emit_signal("got")
	hide()
	pass
