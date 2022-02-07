extends Node

export var difficulties: Dictionary = {
	"randy": 10
}
export var map_path: String = "res://maps/default.map"
export var passive_power = 0.0
export var passive_temperature = 0.0
export var night_index = 0
export var completion_flag = "n1"
export var time_to_completion = 360
export var victory_scene = "res://scenes/victory/victory.tscn"

func run():
	$"/root/EventMan".reset()
	$"/root/EventMan".difficulties = difficulties
	$"/root/EventMan".passive_power = passive_power
	$"/root/EventMan".passive_temperature = passive_temperature
	$"/root/EventMan".night_index = night_index
	$"/root/EventMan".completion_flag = completion_flag
	$"/root/EventMan".time_to_completion = time_to_completion
	$"/root/EventMan".completion_scene = load(victory_scene)
	$"/root/LevelLoader".load_level(map_path)

func set_map(map):
	map_path = map

func set_night(night: int):
	night_index = night + 1;

func set_difficulty(difficulty: int, character: String):
	difficulties[character] = difficulty
