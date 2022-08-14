extends AnimatronicBase
class_name Gabe
onready var night_index = EventMan.night_index

var original_difficulty = 0;
export var flashbang_circuit = "office_vent_flash_momentary"

func _ready():
	animation_player = get_node("gabe/AnimationPlayer")
	if night_index == 0:
		EventMan.circuit_off("save.gabe_glass_broken")
		assume_state(0)
	else:
		assume_state(16)
	var _drop = $"/root/EventMan".connect("on", self, "on")
#	$"/root/EventMan".connect("noisy", self, "noisy")
	_drop = $AimingTimer.connect("timeout", self, "shoot")
	

func difficulty_offset():
	var heat_increase = 0
	var noise_increase = 0
	if $"/root/EventMan".temperature >= CVars.get_float("hot_threshold"):
		heat_increase = ($"/root/EventMan".temperature - CVars.get_float("hot_threshold")) / 6
	if $"/root/EventMan".circuit("noisy") == true:
		noise_increase = CVars.get_float("noisy_diff_boost")
	#if the music playin do the thin
	return (heat_increase + noise_increase)
	
func state_machine():
	if $"/root/EventMan".circuit("lucas.vent") and state in [8, 5]:
		return state
	match state:
		0:
			$GlassBreakingPlayer.play()
			PersistMan.set_flag("gabe_glass_broken", true)
			EventMan.circuit_on("save.gabe_glass_broken")
			return 1
		2:
			var rng = randf()
			if rng > 0.5:
				return 3
			else:
				return 7
		6:
			return 10
		10:
			$GunFumblePlayer.play()
			$AimingTimer.wait_time = CVars.get_float("gabe_base_shoot_time") / difficulty
			$AimingTimer.start()
			return 11
		11:
			# This state is short-circuited so that he can't move until the timer elapses
			print("Gabe in short-circuited state")
			return 11
		12:
			original_difficulty = difficulty
			difficulty = 25
			return 13
		15:
			difficulty = original_difficulty
			return 16
		16:
			return 2
	return state + 1
	# ISSUE HERE

func on(circuit: String):
	if circuit == flashbang_circuit and state == 11:
		$GunShotPlayer.play()
		assume_state(12)

func shoot():
	if state == 11:
		$GunShotPlayer.play()
		$"/root/EventMan".jumpscare("gabe", "gabe")
		$AimingTimer.stop()
		assume_state(12)
		pass
