extends Node

const GAMEPLAY = preload("res://scenes/gameplay/gameplay.tscn")

var map = null

func load_level(level_file: String):
	map = level_file
	var _err = get_tree().change_scene_to(GAMEPLAY)
	call_deferred("setup_level")

func setup_level():
	var completion: Timer = get_node("/root/gameplay/CompletionTimer")
	completion.wait_time = $"/root/EventMan".time_to_completion
	var _err = completion.connect("timeout", get_tree(), "change_scene_to", [$"/root/EventMan".completion_scene])
	_err = completion.connect("timeout", $"/root/EventMan", "completed")
	completion.start()
