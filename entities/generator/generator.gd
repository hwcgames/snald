extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power_regen = .25
var circuit = "generator"
var noise_time = 20
var suppress = false
var generating = false
var gen_time = 10


func _ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	power_regen = properties["power"] if "power" in properties else .25
	circuit = properties["circuit"] if "circuit" in properties else "generator"
	noise_time = properties["noise_time"] if "noise_time" in properties else 10
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")
	$noise_timer.wait_time = noise_time
	$gen_timer.wait_time = gen_time
	
func on(c):
	if c == circuit and not suppress:
		suppress = true
		generating = true
		#$AnimationPlayer.play()
		$noise_timer.start()
		$gen_timer.start()
		$"/root/EventMan".circuit_on("noisy")
		$AudioStreamPlayer.play()
		yield($gen_timer,"timeout")
		generating = false
		yield($noise_timer,"timeout")
		$"/root/EventMan".circuit_off("noisy")
		suppress = false
		$AnimationPlayer.play("GeneratorSpinsDown")

func power_tick():
	if generating == true:
		$"/root/EventMan".power += power_regen
