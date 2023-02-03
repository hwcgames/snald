tool
extends Spatial

const LOADING_BAR: PackedScene = preload("res://scenes/loading_bar.tscn")

func _ready():
	if Engine.editor_hint:
		return
	randomize()
	if not LevelLoader.prebuilt:
		build(LevelLoader.map)
		# Loading screen
		EventMan.pause = true
		var loading_bar = LOADING_BAR.instance()
		add_child(loading_bar)
		var _err = $QodotMap.connect("build_progress", loading_bar, "progress")
		yield($QodotMap, "build_complete")
		for c in loading_bar.get_children():
			for c2 in c.get_children():
				c2.remove_and_skip()
			c.remove_and_skip()
		loading_bar.remove_and_skip()
	else:
		$QodotMap.call_deferred("emit_signal", "build_complete")
	EventMan.start_time = OS.get_unix_time()	
	# Spawn characters
	var difficulties = $"/root/EventMan".difficulties
	for animatronic in difficulties.keys():
		if difficulties[animatronic] == 0:
			continue
		spawn_animatronic(animatronic)
	EventMan.pause = false
	# Enable cheats when running in the editor
	if OS.is_debug_build():
		EventMan.circuit_on("cheater")
	# Start the cutscene if it exists
	if EventMan.start_cutscene:
		CutsceneMan.start_cutscene(EventMan.start_cutscene)
	# Write all save flags as circuits
	for key in PersistMan.persistent_dict.keys():
		var val = PersistMan.persistent_dict[key]
		var circuit = "save."+key
		if val:
			EventMan.circuit_on(circuit)
		else:
			EventMan.circuit_off(circuit)
	# Set up music start timer
	$MusicStarter.wait_time = EventMan.time_before_start_music
	$MusicStarter.start()
	yield($MusicStarter, "timeout")
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = EventMan.song
	$AudioStreamPlayer.play()

func spawn_animatronic(animatronic):
	var scene = "res://animatronics/" + animatronic + "/" + animatronic + ".tscn"
	if File.new().file_exists(scene):
		var instance = load(scene).instance()
		instance.id = animatronic
		instance.difficulty = $"/root/EventMan".difficulties[animatronic]
		add_child(instance)
		instance.add_to_group("animatronics")
	else:
		print("Tried to load an animatronic ", animatronic, " which does not exist.")

func completed_build():
	return

func build(map: String):
	if File.new().file_exists(map):
		$QodotMap.set_map_file(map)
		$QodotMap.verify_and_build()
	else:
		print("Tried to load a map that doesn't exist, exiting to menu")
		var _err = get_tree().change_scene("res://scenes/menu/menu.tscn")
