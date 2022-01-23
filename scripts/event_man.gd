extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# When an animatronic enters a room, a circuit named `animatronic_id.room_id` will turn on, and off when they leave.
signal on(circuit_id)
signal off(circuit_id)

signal jumpscare(character, scene)

signal animatronic_tick

signal power_tick

signal temperature_tick

export var difficulties: Dictionary = {}
export var power: float = 100.0
export var passive_power: float = 0.0
export var passive_temperature: float = 0.0
export var temperature: float = 298.0
export var circuit_states = {}
export var night_index = 0
export var completion_flag = "n1"

onready var power_timer = Timer.new()
onready var temperature_timer = Timer.new()
onready var animatronic_timer = Timer.new()

func _ready():
	add_child(power_timer)
	power_timer.wait_time = 5.0
	power_timer.start()
	power_timer.connect("timeout", self, "power_tick")
	add_child(temperature_timer)
	temperature_timer.wait_time = 5.0
	temperature_timer.start()
	temperature_timer.connect("timeout", self, "temperature_tick")
	add_child(animatronic_timer)
	animatronic_timer.wait_time = 5.0
	animatronic_timer.start()
	animatronic_timer.connect("timeout", self, "animatronic_tick")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset():
	difficulties = {}
	power = 100.0
	passive_power = 0
	temperature = 298.0
	passive_temperature = 0
	circuit_states = {}
	night_index = 0
	power_timer.stop()
	power_timer.start()
	temperature_timer.stop()
	temperature_timer.start()
	animatronic_timer.stop()
	animatronic_timer.start()

func register(animatronic_id: String, difficulty: int):
	difficulties[animatronic_id] = difficulty

func power_tick():
	power -= passive_power
	emit_signal("power_tick")
	print(power)
	power_timer.start()

func temperature_tick():
	temperature -= passive_temperature
	emit_signal("temperature_tick")
	print(temperature)
	temperature_timer.start()

func animatronic_tick():
	emit_signal("animatronic_tick")
	animatronic_timer.start()

func circuit_on(name):
	print(name, " activates")
	circuit_states[name] = true
	emit_signal("on", name)

func circuit_off(name):
	print(name, " deactivates")
	circuit_states[name] = false
	emit_signal("off", name)

func circuit(name):
	return circuit_states[name]

func jumpscare(character, scene_name):
	emit_signal("jumpscare", character, scene_name)

func return_to_title():
	reset()
	get_tree().change_scene("res://scenes/menu/menu.tscn")
