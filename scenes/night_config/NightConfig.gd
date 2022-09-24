extends Node

export var difficulties: Dictionary = {
	"randy": 10
}
export var map_path: String = "maps/default.map"
export var passive_power = 0.0
export var passive_temperature = 0.0
export var night_index = 0
export var completion_flag = "n1"
export var time_to_completion = 360
export var between_scene = "res://scenes/between/dummy.tscn"
export var victory_scene = "res://scenes/victory/victory.tscn"
export var song = preload("res://music/night_ambience.ogg")
export var time_before_start_music = 20.0
export var start_cutscene: PackedScene
export var cvar_ints: Dictionary = Dictionary()
export var cvar_floats: Dictionary = Dictionary()
export var cvar_bools: Dictionary = Dictionary()

func run():
	EventMan.reset()
	EventMan.difficulties = difficulties
	EventMan.passive_power = passive_power
	EventMan.passive_temperature = passive_temperature
	EventMan.night_index = night_index
	EventMan.completion_flag = completion_flag
	EventMan.time_to_completion = time_to_completion
	EventMan.between_scene = load(between_scene)
	EventMan.completion_scene = load(victory_scene)
	EventMan.song = song
	EventMan.time_before_start_music = time_before_start_music
	EventMan.start_cutscene = start_cutscene
	
	# Write cvars
	for key in cvar_ints.keys():
		CVars.set_int(key, cvar_ints[key])
	for key in cvar_floats.keys():
		CVars.set_float(key, cvar_floats[key])
	for key in cvar_bools.keys():
		CVars.set_bool(key, cvar_bools[key])
	
	LevelLoader.load_level(map_path)

func set_map(map):
	map_path = map

func set_night(night: int):
	night_index = night + 1;

func set_difficulty(difficulty: int, character: String):
	difficulties[character] = difficulty

func set_duration(seconds: float):
	time_to_completion = seconds

