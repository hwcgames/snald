extends AnimatronicBase
onready var night_index = EventMan.night_index

var original_difficulty = 0;
export var flashbang_circuit = "office_vent_flash_momentary"

func _ready():
	animation_player = get_node("gabe/AnimationPlayer")
	if night_index == 0:
		assume_state(0)
	else:
		assume_state(16)
	$"/root/EventMan".connect("on", self, "on")
	$AimingTimer.connect("timeout", self, "shoot")

func state_machine():
	match state:
		0:
			$GlassBreakingPlayer.play()
			return 1
		2:
			var rng = randf()
			if rng > 0.5:
				return 3
			else:
				return 7
		10:
			$GunFumblePlayer.play()
			$AimingTimer.wait_time = 50 / difficulty
			$AimingTimer.start()
			return 11
		11:
			# This state is short-circuited so that he can't move until the timer elapses
			print("Gabe in short-circuited state")
			return 11
		12:
			original_difficulty = difficulty
			difficulty = 20
			return 13
		15:
			difficulty = original_difficulty
			return 16
		16:
			return 2
	return state + 1

func on(circuit: String):
	if circuit == flashbang_circuit and state == 11:
		$GunShotPlayer.play()
		assume_state(12)

func shoot():
	if state == 11:
		$GunShotPlayer.play()
		$"/root/EventMan".jumpscare("gabe", "gabe")
		$AimingTimer.stop()
		pass
