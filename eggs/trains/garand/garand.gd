extends EasterEgg

var text = "Learned about Gabe's gun"

func _ready():
	hide()
	EventMan.connect("off", self, "off")

func off(circuit: String):
	if circuit == "gabe.0":
		show()
