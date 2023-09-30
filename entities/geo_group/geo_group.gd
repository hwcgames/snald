extends QodotEntity
class_name GeometryGroup

var circuit = "default"

func _ready():
	yield(get_parent(), "build_complete")
	var show_at_start = (properties["starting_state"] == 1) if "starting_state" in properties else true
	circuit = properties["circuit"] if "circuit" in properties else "default"
	if show_at_start:
		show()
	else:
		hide()
	var _drop = EventMan.connect("on", self, "on")
	_drop = EventMan.connect("off", self, "off")
	_drop = EventMan.connect("reset", self, "reset")
	pass # Replace with function body.

func on(c: String):
	if c == circuit:
		show()

func off(c: String):
	if c == circuit:
		hide()

func reset():
	var show_at_start = (properties["starting_state"] == 1) if "starting_state" in properties else true
	if show_at_start:
		show()
	else:
		hide()
