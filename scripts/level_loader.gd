extends Node

const GAMEPLAY = preload("res://scenes/gameplay/gameplay.tscn")

var map = null

const custom_map_supported_systems = [
	"Haiku",
	"OSX",
	"Windows",
	"X11"
]

var prebuilt = not (OS.get_name() in custom_map_supported_systems)

func load_level(level_file: String, test_mode = false):
	map = level_file
	if prebuilt:
		print("We're on a platform where custom maps aren't supported; loading the pre-built version of the level.")
		var _err = get_tree().change_scene_to(load("res://scenes/gameplay/gameplay-preloaded.tscn"))
	else:
		if test_mode:
			var _err = get_tree().change_scene_to(load("res://scenes/test/test.tscn"))
		else:
			var _err = get_tree().change_scene_to(GAMEPLAY)
	call_deferred("setup_level", test_mode)

func setup_level(test_mode = false):
	if not test_mode:
		var completion: Timer = get_node("/root/gameplay/CompletionTimer")
		completion.wait_time = $"/root/EventMan".time_to_completion
		var _err = completion.connect("timeout", $"/root/EventMan", "completed")
		completion.start()
	else:
		EventMan.circuit_on("test_mode")
