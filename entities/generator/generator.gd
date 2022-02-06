extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power_regen = .25
var circuit = "generator"
var noise_time = 10
var suppress = false
var generating = false


func _ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	power_regen = properties["power"] if "power" in properties else .25
	circuit = properties["circuit"] if "circuit" in properties else "generator"
	noise_time = properties["noise_time"] if "noise_time" in properties else 10
	$"/root/EventMan".connect("on", self, "on")
	$"/root/EventMan".connect("off", self, "off")
	$"/root/EventMan".connect("power_tick", self, "power_tick")
	$noise_timer.wait_time = noise_time
	
func on(c):
	if c == circuit and not suppress:
		suppress = true
		generating = true
		#$AnimationPlayer.play()
		$noise_timer.start()
		$"/root/EventMan".circuit_on("noisy")
		yield($noise_timer,"timeout")
		$"/root/EventMan".circuit_off("noisy")
		suppress = false
		generating = false

func power_tick():
	if generating == true:
		$"/root/EventMan".power += power_regen
