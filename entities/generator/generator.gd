extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = 1
var power_regen = 10
var circuit = "generator"
var noise_time = 10
var suppress = false


func ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	noise = properties["noise"] if "noise" in properties else 1
	power_regen = properties["power"] if "power" in properties else 10
	circuit = properties["circuit"] if "circuit" in properties else "generator"
	noise_time = properties["noise_time"] if "noise_time" in properties else 10
	$"/root/EventMan".connect("on", self, "on")
	$"/root/EventMan".connect("off", self, "off")
	$noise_timer.wait_time = noise_time
	
func on(c):
	if c == circuit and not suppress:
		suppress = true
		#$AnimationPlayer.play()
		$"/root/EventMan".power += power_regen
		#yield($AnimationPlayer,"animation_finished")
		$noise_timer.start()
		$"/root/EventMan".circuit_on("noisy")
		yield($noise_timer,"timeout")
		$"/root/EventMan".circuit_off("noisy")
		suppress = false
	
