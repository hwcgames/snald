extends Label

var temperature = 0
var power = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	temperature_tick()
	$"/root/EventMan".connect("power_tick", self, "power_tick")
	power_tick()
	$"/root/EventMan".connect("jumpscare", self, "jumpscare")
	pass # Replace with function body.

func temperature_tick():
	temperature = $"/root/EventMan".temperature
	update()

func power_tick():
	power = $"/root/EventMan".power
	call_deferred("update")

func jumpscare(char_, anim_):
	if not $"../../../".DEBUG:
		hide()

func update():
	text = ""
	text += "Power: "
	text += str(power)
	text += "%\nTemperature: "
	text += str(temperature)
	text += " degrees Kelvin"
