extends HBoxContainer

onready var power: TextureProgress = $PowerMeter
onready var temp: TextureProgress = $TemperatureMeter
onready var clock: TextureProgress = $MiniClock

func _ready():
	refresh()

func refresh():
	get_tree().create_timer(1).connect("timeout", self, "refresh")
	power.value = EventMan.power;
	temp.value = EventMan.temperature;
	clock.value = 100 * (OS.get_unix_time() - EventMan.start_time) / EventMan.time_to_completion;
	if EventMan.temperature < temp.min_value || EventMan.temperature > temp.max_value:
		temp.modulate = Color.white - temp.modulate;
	else:
		temp.modulate = Color.white;
	if power.value < 10:
		power.modulate = Color.white - power.modulate;
	else:
		power.modulate = Color.white;
	if clock.value > 90:
		clock.modulate = Color.white - clock.modulate;
	else:
		clock.modulate = Color.white;
	pass
