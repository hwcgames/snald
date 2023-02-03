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
	pass
