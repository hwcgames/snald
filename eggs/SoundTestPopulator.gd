extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	find_all_sounds("res://music")
	pass # Replace with function body.

func find_all_sounds(path: String):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, false)
	var file_name = dir.get_next()
	while file_name != '':
		if dir.current_is_dir():
			find_all_sounds(path + "/" + file_name)
		else:
			for extension in [".ogg", ".mp3", ".wav"]:
				if file_name.ends_with(extension):
					var btn = Button.new()
					btn.text = file_name
					btn.size_flags_horizontal = SIZE_SHRINK_CENTER
					btn.connect("pressed", $"%AudioStreamPlayer", "set", ["stream", load(path + "/" + file_name)])
					add_child(btn)
		file_name = dir.get_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
