extends Node

export var difficulties: Dictionary = {
	"randy": 10
}
export var map_path: String = "res://maps/default.map"
export var passive_power = 0.0
export var passive_temperature = 0.0
export var night_index = 0

func run():
	$"/root/EventMan".reset()
	$"/root/EventMan".difficulties = difficulties
	$"/root/EventMan".passive_power = passive_power
	$"/root/EventMan".passive_temperature = passive_temperature
	$"/root/EventMan".night_index = night_index
	$"/root/LevelLoader".load_level(map_path)

func set_map(map):
	map_path = map

func set_difficulty(character: String, difficulty: int):
	difficulties[character] = difficulty
