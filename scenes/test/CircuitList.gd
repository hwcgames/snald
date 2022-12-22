extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()
	EventMan.connect("on", self, "on")
	EventMan.connect("off", self, "off")
	pass # Replace with function body.

func on(_c):
	refresh()
func off(_c):
	refresh()

func refresh():
	for c in get_children():
		c.queue_free()
	for c in EventMan.circuit_states:
		var button = Button.new()
		var state = EventMan.circuit(c);
		button.text = c + ": " + str(state);
		if state:
			button.connect("pressed", EventMan, "circuit_off", [c])
		else:
			button.connect("pressed", EventMan, "circuit_on", [c])
		add_child(button)
