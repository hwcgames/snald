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
	$"%Power/Number".text = str(power) + "%"
	$"%Temperature/Number".text = str(temperature) + " K"
	var timeFrac: float = float(OS.get_unix_time() - EventMan.start_time) / float(EventMan.time_to_completion);
	var minutes = ceil(6 * 60 * timeFrac / 5) * 5
	var hours = floor(minutes / 60)
	minutes = int(floor(minutes)) % 60
	if hours == 0:
		hours = 12
	$"%Time/Number".text = str(hours) + ':' + ('0' if minutes < 10 else '') + str(minutes)
