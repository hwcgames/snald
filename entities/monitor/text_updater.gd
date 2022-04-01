extends Node

var temperature = 0
var power = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = $"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	temperature_tick()
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")
	power_tick()
	pass # Replace with function body.

func temperature_tick():
	temperature = $"/root/EventMan".temperature
	update()

func power_tick():
	power = $"/root/EventMan".power
	call_deferred("update")

func update():
	$Power/Number.text = str(power) + "%"
	$Temperature/Number.text = str(temperature) + " K"
