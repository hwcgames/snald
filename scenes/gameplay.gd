extends Spatial

func _ready():
	randomize()
	var map = $"/root/LevelLoader".map
	if File.new().file_exists(map):
		if "res://" in map:
			var split = map.split("/")
			var input = File.new()
			input.open(map, File.READ)
			var output = File.new()
			map = "user://" + split[len(split)-1]
			print(map)
			output.open(map, File.WRITE)
			output.store_string(input.get_as_text())
			output.flush()
			map = output.get_path_absolute()
		$QodotMap.set_map_file(map)
		$QodotMap.verify_and_build()
	else:
		print("Tried to load a map that doesn't exist, exiting to menu")
		get_tree().change_scene("res://scenes/menu.tscn")
	yield($QodotMap, "build_complete")
	var difficulties = $"/root/EventMan".difficulties
	for animatronic in difficulties.keys():
		var scene = "res://animatronics/" + animatronic + "/" + animatronic + ".tscn"
		if File.new().file_exists(scene):
			var instance = load(scene).instance()
			instance.id = animatronic
			instance.difficulty = difficulties[animatronic]
			add_child(instance)
		else:
			print("Tried to load an animatronic ", animatronic, " which does not exist.")

func completed_build():
	return
	print($QodotMap.get_children())
