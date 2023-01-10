extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var persistent_dict: Dictionary = {}

signal got_flag(flag)
signal lost_flag(flag)

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

func get_key(key, default=false):
	return persistent_dict[key] if key in persistent_dict else default

func set_flag(key: String, val=true):
	if persistent_dict.get(key, false) != val:
		emit_signal(
			"got_flag" if val else "lost_flag",
			val
		)
	persistent_dict[key] = val
