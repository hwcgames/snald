extends AnimatronicBase
class_name Jojo
onready var night = $"/root/EventMan".night_index
export var office_door_circuit = "office_door_toggle"
func difficulty_offset():
	return 69
var difficulty_offset_2 = 0
	# heat and noise makes the funny
	

var heat_increase = 0
var noise_increase = 0

func gen_time():
	return rand_range(130 - (6 * (difficulty + heat_increase + noise_increase)), 180 - (8 * difficulty + heat_increase + noise_increase))

func animatronic_tick():
	heat_increase = ($"/root/EventMan".temperature - 90) / 6 if $"/root/EventMan".temperature >= 90 else 0
	noise_increase = 8 if $"/root/EventMan".circuit("noisy") == true else 0
	$MovementTimer.wait_time = gen_time()
	assume_state(state_machine())
	$MovementTimer.start()

func _ready():
	animation_player = get_node("jojo/AnimationPlayer")
	$MovementTimer.wait_time = gen_time()
	$MovementTimer.start()
	assume_state(0)
	
func state_machine():
	if state in [0,1,2]:
		$MovementTimer.wait_time = gen_time()
		return state + 1 
	if state in [4,5,6,7,8,9]:
		$MovementTimer.wait_time = 0.3 if state == 9 else 1
		glide_to_state(state+1, 0.29 if state == 9 else 0.98)
		return state
	match state:
		3:
			$MovementTimer.wait_time = 1
			glide_to_state(4, 0.98)
			return state
		10:
			if EventMan.circuit(office_door_circuit):
				$"/root/EventMan".jumpscare("jojo", "jojo")
				return 0
			else:
				# $DogSoundsPlayer.play()   #actually add that sound ok???
				$MovementTimer.wait_time = gen_time()
				return 0
