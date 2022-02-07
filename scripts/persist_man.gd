extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var persistent_dict: Dictionary = {}

func _ready():
	load_game();

func load_game():
	var game = File.new()
	if not game.file_exists("user://snald.save"):
		return # Loading is a no-op when no save exists
	game.open("user://snald.save", File.READ)
	persistent_dict = parse_json(game.get_as_text())

func save_game():
	var game = File.new()
	game.open("user://snald.save", File.WRITE)
	game.store_string(to_json(persistent_dict))

func reset():
	persistent_dict = {}
	save_game()
	get_tree().quit()
