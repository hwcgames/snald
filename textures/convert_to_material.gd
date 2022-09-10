extends MainLoop;

# Converts all of the .tres files in the textures directory to .material

func _initialize():
	pass

func _idle(_delta):
	var dir = Directory.new()
	dir.open("res://textures")
	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while (file_name != ""):
		print(file_name)
		if file_name.ends_with(".tres"):
			var mat = ResourceLoader.load("res://textures/"+file_name)
			if mat is SpatialMaterial:
				var new_name = file_name.replace(".tres", ".material")
				ResourceSaver.save("res://textures/"+new_name, mat)
		file_name = dir.get_next()
	return true
