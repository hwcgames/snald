extends AnimatronicBase
onready var night = $"/root/EventMan".night_index
export var office_door_circuit = "office_door_toggle"
func difficulty_offset():
	return 69
var difficulty_offset_2 = 0
	# heat and noise makes the funny
	

var heat_increase = 0
var noise_increase = 0

func animatronic_tick():
	heat_increase = ($"/root/EventMan".temperature - 90) / 6 if $"/root/EventMan".temperature >= 90 else 0
	noise_increase = 2 if $"/root/EventMan".circuit("noisy") == true else 0
	$MovementTimer.wait_time = rand_range(130 - (6 * (difficulty + heat_increase + noise_increase)), 180 - (8 * difficulty + heat_increase + noise_increase))
	assume_state(state_machine())
	$MovementTimer.start()

func _ready():
	animation_player = get_node("AnimationPlayer")
	$MovementTimer.wait_time = rand_range(130 - (6 * (difficulty + heat_increase + noise_increase)), 180 - (8 * difficulty + heat_increase + noise_increase))
	$MovementTimer.connect("timeout", self, "animatronic_tick")
	$MovementTimer.start()
	assume_state(0)
	
func state_machine():
	if state in [0,1,2]:
		$MovementTimer.wait_time = rand_range((130 - (6 * difficulty + heat_increase + noise_increase)), (180 - (8 * difficulty + heat_increase + noise_increase)))
		return state + 1 
	if state in [4,5,6,7,8,9]:
		return state + 1
	match state:
		3:
			$MovementTimer.wait_time = 1
			return 4
		10:
			if (office_door_circuit in $"/root/EventMan".circuit_states) and ($"/root/EventMan".circuit_states[office_door_circuit]):
				$"/root/EventMan".jumpscare("jojo", "door")
				return 0
			else:
				# $DogSoundsPlayer.play()   #actually add that sound ok???
				$MovementTimer.wait_time = rand_range(130 - (6 * difficulty + heat_increase + noise_increase), 180 - (8 * difficulty + heat_increase + noise_increase))
				return 0
