extends AnimatronicBase
class_name Red
export var office_door_circuit = "office_door_toggle"
var wait_counter = 3

func _ready():
	assume_state(0)
	$MovementTimer.start()
	var _drop = $"/root/EventMan".connect("off", self, "off")
	
func difficulty_offset():
	var heat_increase = 0
	var noise_increase = 0
	if $"/root/EventMan".temperature >= CVars.get_float("hot_threshold"):
		heat_increase = ($"/root/EventMan".temperature - CVars.get_float("hot_threshold")) / 6
	if $"/root/EventMan".circuit("noisy") == true:
		noise_increase = CVars.get_float("noisy_diff_boost")
	#if the music playin do the thin
	print (heat_increase + noise_increase)
	return (heat_increase + noise_increase)

func state_machine():
	match state:
		0:
			if wait_counter > 0:
				wait_counter -= 1
				return 0
			var roll = randf()
			if roll < .5:
				return 1
			else:
				return 3
		2:
			var roll = randf()
			if roll <.66:
				var _drop = $AttackTimer.connect("timeout", self, "attempt_attack")
				$AttackTimer.wait_time = 31 - difficulty - difficulty_offset()
				$AttackTimer.start()
				return 6
			else:
				return 1
		3:
			var roll = randf()
			if roll <.66:
				return 4
			else:
				return 0
		5:
			var roll = randf()
			if roll <.66:
				var _drop = $AttackTimer.connect("timeout", self, "attempt_attack")
				$AttackTimer.wait_time = 31 - difficulty - difficulty_offset()
				$AttackTimer.start()
				return 6
			else:
				return 4
		6: 
			return 6
			
	var roll = randf()
	if roll <.66:
		return state + 1
	else:
		return state - 1

func attempt_attack():
	$AttackTimer.stop()
	if not $"/root/EventMan".circuit(office_door_circuit):
		wait_counter = 3
		assume_state(0)
	else:
		$"/root/EventMan".jumpscare("redman", "redman")
		assume_state(0)
		
func off(circuit):
	if circuit == office_door_circuit and state == 6:
		$AttackTimer.stop()
		$AttackTimer.wait_time = 3 + sqrt(difficulty + difficulty_offset())
		$AttackTimer.start()
		
