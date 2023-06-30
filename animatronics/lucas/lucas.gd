extends AnimatronicBase
class_name Lucas

export var window_circuit = "window_toggle"
export var office_door_circuit = "office_door_toggle"
export var office_vent_flash = "office_vent_flash_momentary"
export var camera_entrance = "camera.foyer"

var hunt_accumulation = 0.0
var hunt_target = null
var have_hunted = false

onready var night = $"/root/EventMan".night_index

onready var HUNT_TARGETS = [
	{"window": 1},
	{"window": 0.7, "door": 0.2, "vent": 0.1},
	{"window": 0.5, "door": 0.25, "vent": 0.25},
	{"window": 0.5, "door": 0.25, "vent": 0.25},
	{"window": 0.5, "door": 0.25, "vent": 0.25}
][night]

var ROOM_CANDIDATES = {
	0: [1],
	1: [0, 2, 7],
	2: [1, 3],
	3: [2, 4],
	4: [3, 5, 6],
	5: [4],
	6: [4, 7],
	7: [1, 6, 8],
	8: [7]
}

var HUNT_PATHS = {
	"window": {
		0: 1,
		1: 2,
		2: 3,
		3: 4,
		4: 9,
		5: 4,
		6: 4,
		7: 6,
		8: 7,
		9: 10,
	},
	"door": {
		0: 1,
		1: 13,
		2: 1,
		3: 2,
		4: 6,
		5: 4,
		6: 7,
		7: 13,
		8: 7
	},
	"vent": {
		0: 1,
		1: 2,
		2: 14,
		3: 2,
		4: 3,
		5: 4,
		6: 7,
		7: 8,
		8: 15,
		14: 16,
		15: 16
	}
}

func _ready():
	call_deferred("assume_state", 0)
	animation_player = get_node("lucas/AnimationPlayer")
	# Add listener for powertick so we can run special behavior when it runs out
	var _drop = EventMan.connect("power_tick", self, "power_tick")
	EventMan.connect("reset", self, "reset")

var jumpscaring = false

func reset():
	EventMan.disconnect("on", self, "attack_if_window_opens_circuit_handler")
	EventMan.disconnect("on", self, "vent_flashbang")

	hunt_accumulation = 0.0
	hunt_target = null
	have_hunted = false

func power_tick():
	if EventMan.power > 0 or jumpscaring:
		return
	var wait_time = (randi() % 30) + 10;
	var t = Timer.new()
	add_child(t)
	t.start(wait_time)
	print("Waiting " + str(wait_time) + " seconds to jumpscare")
	jumpscaring = true
	yield(t, "timeout")
	EventMan.jumpscare("lucas", "powerout")

	
func state_machine():
	animation_player = $lucas/AnimationPlayer
	if hunt_target == "window" and night == 0 and not have_hunted and state in [3,4,5,6]:
		have_hunted = true
		var _drop = $"/root/EventMan".connect("off", self, "wait_for_camera_entrance")
		$N1WaitTimer.wait_time = CVars.get_float("lucas_n1_wait_time")
		_drop = $N1WaitTimer.connect("timeout", self, "wait_for_camera_entrance", [camera_entrance])
		$N1WaitTimer.start()
		return 18
	if state in [2,8] and hunt_target == "vent" and EventMan.circuit("gabe.vent"):
		return state
	match state:
		9:
			play_approach_sound()
			assume_state(10)
			animation_player.play("walking_to_window_loop")
			# animation_player.connect("animation_finished", self, "walked_up_to_window")
			# return 10
			yield(glide_to_state(11, 7.0), "completed")
			var _drop = $"/root/EventMan".connect("on", self, "attack_if_window_opens_circuit_handler")
			if EventMan.circuit(window_circuit):
				hide()
				$"/root/EventMan".jumpscare("lucas", "window")
			return -1
		10:
			return -1
		11:
			$"/root/EventMan".disconnect("on", self, "attack_if_window_opens_circuit_handler")
			var _drop = animation_player.connect("animation_finished", self, "walked_away_from_window")
			play_depart_sound()
			animation_player.play("walking_to_window_loop")
			glide_to_state(12, 7.0)
			return -1
		12:
			# return 12
			hunt_target = null
			hunt_accumulation = 0.0
			return go_back()
		13:
			if EventMan.circuit(office_door_circuit):
				$"/root/EventMan".jumpscare("lucas", "door")
				return 0
			else:
				hunt_target = null
				hunt_accumulation = 0
				return go_back()
		16:
			$GunFumblePlayer2.play()
			var _drop = $"/root/EventMan".connect("on", self, "vent_flashbang")
			return 17
		17:
			$"/root/EventMan".disconnect("on", self, "vent_flashbang")
			hunt_target = null
			hunt_accumulation = 0.0
			return go_back()
		18:
			return 18
	check_hunting()
	if hunt_target == null:
		return roll_wander()
	else:
		return hunt_path()
	
	
func go_back():
	if randf() <.4:
		return 0
	else:
		return int(round(rand_range(1,8)))
	
func check_hunting():
	if hunt_target == null:
		if randf() < hunt_accumulation:
			var hunt_target_number = randf()
			var accumulator = 0
			for key in HUNT_TARGETS.keys():
				if key == "vent" and EventMan.circuit("gabe.vent"):
					continue
				if hunt_target_number < HUNT_TARGETS[key]+accumulator:
					hunt_target = key
					break
				else:
					accumulator += HUNT_TARGETS[key]
			print("Lucas begins hunting for ", hunt_target)
		else:
			hunt_accumulation += CVars.get_float("lucas_hunt_accumulation_rate") * difficulty
func play_approach_sound():
	if 0 == floor(rand_range(0,1)):
		$approach1.play()
	else:
		$approach2.play()
func play_depart_sound():
	if 0 == floor(rand_range(0,1)):
		$depart1.play()
	else:
		$depart2.play()
		
func roll_wander():
	var possibilities = ROOM_CANDIDATES[state]
	var index = floor(rand_range(0, len(possibilities)))
	return possibilities[index]

func hunt_path():
	return HUNT_PATHS[hunt_target][state]

func attack_if_window_opens_circuit_handler(circuit: String):
	if state == 0:
		return
	if circuit == window_circuit:
		$"/root/EventMan".jumpscare("lucas", "window")
		hide()

func walked_up_to_window():
	#animation_player.disconnect("animation_finished", self, "walked_up_to_window")
	play_approach_sound()
	var _drop = $"/root/EventMan".connect("on", self, "attack_if_window_opens_circuit_handler")
	assume_state(11)

func walked_away_from_window():
	#animation_player.disconnect("animation_finished", self, "walked_away_from_window")
	play_depart_sound()
	hunt_target = null
	hunt_accumulation = 0.0
	assume_state(0)

func vent_flashbang(circuit: String):
	if state == 0:
		return
	if circuit == office_vent_flash:
		$"/root/EventMan".jumpscare("lucas", "vent")

func wait_for_camera_entrance(circuit: String):
	if circuit == camera_entrance:
		$"/root/EventMan".disconnect("off", self, "wait_for_camera_entrance")
		$N1WaitTimer.disconnect("timeout", self, "wait_for_camera_entrance")
		assume_state(9)

func difficulty_offset():
	var heat_increase = 0
	var noise_increase = 0
	if $"/root/EventMan".temperature >= CVars.get_float("hot_threshold"):
		heat_increase = ($"/root/EventMan".temperature - CVars.get_float("hot_threshold")) / 6
	if $"/root/EventMan".circuit("noisy") == true:
		noise_increase = CVars.get_float("noisy_diff_boost")
	#if the music playin do the thin
	return (heat_increase + noise_increase + 3)

onready var gun = $"lucas/Armature/Skeleton/BoneAttachment4/Plane001"
const gun_anims = [
	"armory_peek"
]
onready var train = $"lucas/Armature/Skeleton/BoneAttachment3/Cube"
const train_anims = [
	"lucas_ns_hall"
]

func check_attachments(_state):
	var anim = animation_player.current_animation;
	if !anim:
		return
	gun.visible = anim in gun_anims
	train.visible = anim in train_anims
