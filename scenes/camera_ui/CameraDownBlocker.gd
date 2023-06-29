extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventMan.connect("on", self, "on")
	EventMan.connect("off", self, "off")
	hide()
	pass # Replace with function body.

func on(circuit: String):
	if circuit == "computer_is_down":
		show()
		$"%MapTexture".hide()

func off(circuit: String):
	if circuit == "computer_is_down":
		hide()
		$"%MapTexture".show()
