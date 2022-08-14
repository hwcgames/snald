extends StaticBody
class_name EasterEgg

signal got

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and visible:
			clicked()

func clicked():
	emit_signal("got")
	hide()
	pass
