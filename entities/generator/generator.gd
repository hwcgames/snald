extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power_regen = .25
var circuit = "generator"
var noise_time = 20
var generating = false
var gen_time = 10
var power_increment_tick = 0

onready var model = $Generator
onready var tween = Tween.new()

func _ready():
	yield(get_parent(), "build_complete")
	add_child(tween)
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	power_regen = properties["power"] if "power" in properties else .25
	circuit = properties["circuit"] if "circuit" in properties else "generator"
	noise_time = properties["noise_time"] if "noise_time" in properties else 10
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")

var noisy_was_on: bool = false

func on(c):
	if c == circuit and not $"/root/EventMan".temperature == CVars.get_float("generator_fail_threshold"):
		generating = true
		#$AnimationPlayer.play()
		if EventMan.circuit("noisy"):
			noisy_was_on = true
		else:
			noisy_was_on = false
			$"/root/EventMan".circuit_on("noisy")
		$AudioStreamPlayer.play()
	else:
		#play too cold sfx
		off(c)
	model.on()

func off(c):
	if c == circuit:
		generating = false
		if not noisy_was_on:
			$"/root/EventMan".circuit_off("noisy")
		$AudioStreamPlayer.stop()
		$AnimationPlayer.play("GeneratorSpinsDown")
		power_regen = properties["power"] if "power" in properties else .25
	model.off()


func power_tick():
	if generating == true and $"/root/EventMan".power > 0:
		$"/root/EventMan".power += power_regen
		if power_regen <(1):
			if power_increment_tick == 2:
				power_increment_tick = 0
				power_regen += .1
			else:
				power_increment_tick += 1
		model.energy = min(power_regen, 1)
	var desired_pitch
	if EventMan.power > 95:
		desired_pitch = 2.0
	else:
		desired_pitch = 1.0
	if $AudioStreamPlayer.pitch_scale != desired_pitch:
		tween.interpolate_property($AudioStreamPlayer, "pitch_scale", $AudioStreamPlayer.pitch_scale, desired_pitch, 0.5)
		tween.start()
