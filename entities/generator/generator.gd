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


func _ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	power_regen = properties["power"] if "power" in properties else .25
	circuit = properties["circuit"] if "circuit" in properties else "generator"
	noise_time = properties["noise_time"] if "noise_time" in properties else 10
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")
	
	
func on(c):
	if c == circuit and not $"/root/EventMan".temperature == 20:
		generating = true
		#$AnimationPlayer.play()
		$"/root/EventMan".circuit_on("noisy")
		$AudioStreamPlayer.play()
	else:
		#play too cold sfx
		off(c)
		
func off(c):
	if c == circuit:
		generating = false
		$"/root/EventMan".circuit_on("noisy")
		$AudioStreamPlayer.stop()
		$AnimationPlayer.play("GeneratorSpinsDown")
		power_regen = properties["power"] if "power" in properties else .25


func power_tick():
	if generating == true and $"/root/EventMan".power > 0:
		$"/root/EventMan".power += power_regen
		if power_regen <(1):
			if power_increment_tick == 4:
				power_increment_tick = 0
				power_regen += .1
			else:
				power_increment_tick += 1
