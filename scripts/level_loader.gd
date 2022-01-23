extends Node

const GAMEPLAY = preload("res://scenes/gameplay/gameplay.tscn")

var map = null

func load_level(level_file: String):
	map = level_file
	return get_tree().change_scene_to(GAMEPLAY)
