extends AnimatronicBase
onready var night_index = EventMan.night_index

var original_difficulty = 0;
export var flashbang_circuit = "office_vent_flash_momentary"

func _ready():
	if night_index == 0:
		assume_state(0)
	else:
		assume_state(16)
	$"/root/EventMan".connect("animatronic_tick", self, "animatronic_tick")
	$"/root/EventMan".connect("on", self, "on")
	$AimingTimer.connect("timeout", self, "shoot")

func state_machine():
	match state:
		0:
			$GlassBreakingPlayer.play()
			return 1
		1: 
			return 2
		2:
			var rng = randf()
			if rng > 0.5:
				return 3
			else:
				return 7
		3:
			return 4
		4:
			return 5
		5:
			return 6
		6:
			return 10
		7:
			return 8
		8:
			return 9
		9:
			return 10
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
		13:
			return 14
		14:
			return 15
		15:
			difficulty = original_difficulty
			return 16
		16:
			return 2

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
