extends Node

const GAMEPLAY = preload("res://scenes/gameplay/gameplay.tscn")

var map = null

func load_level(level_file: String):
	map = level_file
	get_tree().change_scene_to(GAMEPLAY)
	call_deferred("setup_level")

func setup_level():
	var completion: Timer = get_node("/root/gameplay/CompletionTimer")
	completion.wait_time = $"/root/EventMan".time_to_completion
	completion.connect("timeout", get_tree(), "change_scene_to", [$"/root/EventMan".completion_scene])
	completion.connect("timeout", $"/root/EventMan", "completed")
	completion.start()
