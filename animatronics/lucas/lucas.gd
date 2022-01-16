extends AnimatronicBase

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
	{"window": 0.5, "door": 0.35, "vent": 0.15},
	{"window": 0.4, "door": 0.35, "vent": 0.25},
	{"window": 0.4, "door": 0.35, "vent": 0.25}
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
		2: 9,
		3: 2,
		4: 3,
		5: 4,
		6: 4,
		7: 1,
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

func state_machine():
	if hunt_target == "window" and night == 0 and not have_hunted and state in [1,2,3]:
		have_hunted = true
		$"/root/EventMan".connect("off", self, "wait_for_camera_entrance")
		return 18
	match state:
		10:
			# animation_player.connect("animation_finished", self, "walked_up_to_window")
			# return 10
			return 11
		11:
			$"/root/EventMan".disconnect("off", self, "attack_if_window_opens_circuit_handler")
			animation_player.connect("animation_finished", self, "walked_away_from_window")
			return 12
		12:
			# return 12
			return 0
		13:
			if $"/root/EventMan".circuit_states[office_door_circuit]:
				$"/root/EventMan".jumpscare("lucas", "door")
				return 0
			else:
				return 0
		16:
			$AudioStreamPlayer3D.play()
			$"/root/EventMan".connect("on", self, "vent_flashbang")
			return 17
		17:
			$"/root/EventMan".disconnect("on", self, "vent_flashbang")
			hunt_target = null
			hunt_accumulation = 0.0
			return 0
		18:
			return 18
	check_hunting()
	if hunt_target == null:
		return roll_wander()
	else:
		return hunt_path()

func check_hunting():
	if hunt_target == null:
		if randf() < hunt_accumulation:
			var hunt_target_number = randf()
			for key in HUNT_TARGETS.keys():
				if key == "vent" and "gabe.vent" in $"/root/EventMan".circuit_states and $"/root/EventMan".circuit_states["gabe.vent"]:
					continue
				if hunt_target_number < HUNT_TARGETS[key]:
					hunt_target = key
					break
			print("Lucas begins hunting for ", hunt_target)
		else:
			hunt_accumulation += 0.02 * difficulty

func roll_wander():
	var possibilities = ROOM_CANDIDATES[state]
	var index = floor(rand_range(0, len(possibilities)))
	return possibilities[index]

func hunt_path():
	return HUNT_PATHS[hunt_target][state]

func attack_if_window_opens_circuit_handler(circuit: String):
	if circuit == window_circuit:
		$"/root/EventMan".jumpscare("lucas", "window")

func walked_up_to_window():
	animation_player.disconnect("animation_finished", self, "walked_up_to_window")
	$"/root/EventMan".connect("off", self, "attack_if_window_opens_circuit_handler")
	assume_state(11)

func walked_away_from_window():
	animation_player.disconnect("animation_finished", self, "walked_away_from_window")
	hunt_target = null
	hunt_accumulation = 0.0
	assume_state(0)

func vent_flashbang(circuit: String):
	if circuit == office_vent_flash:
		$"/root/EventMan".jumpscare("lucas", "vent")

func wait_for_camera_entrance(circuit: String):
	if circuit == camera_entrance:
		$"/root/EventMan".disconnect("off", self, "wait_for_camera_entrance")
		assume_state(9)

func difficulty_offset():
	return 10
