extends Spatial

const LOADING_BAR: PackedScene = preload("res://scenes/loading_bar.tscn")

func _ready():
	randomize()
	var map = $"/root/LevelLoader".map
	if File.new().file_exists(map):
		$QodotMap.set_map_file(map)
		$QodotMap.verify_and_build()
	else:
		print("Tried to load a map that doesn't exist, exiting to menu")
		var _err = get_tree().change_scene("res://scenes/menu/menu.tscn")
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
	# Spawn characters
	var difficulties = $"/root/EventMan".difficulties
	for animatronic in difficulties.keys():
		if difficulties[animatronic] == 0:
			continue
		var scene = "res://animatronics/" + animatronic + "/" + animatronic + ".tscn"
		if File.new().file_exists(scene):
			var instance = load(scene).instance()
			instance.id = animatronic
			instance.difficulty = difficulties[animatronic]
			add_child(instance)
			instance.add_to_group("animatronics")
		else:
			print("Tried to load an animatronic ", animatronic, " which does not exist.")
	EventMan.pause = false
	# Enable cheats when running in the editor
	if OS.is_debug_build():
		EventMan.circuit_on("cheater")
	# Set up phone guy
	if $FunnyPhone == null: # Ensure we don't step on the easter egg phone audio
		$AudioStreamPlayer.stream = EventMan.phone_audio
		$AudioStreamPlayer.play()
	# Set up music start timer
	$MusicStarter.wait_time = EventMan.time_before_start_music
	$MusicStarter.start()
	yield($MusicStarter, "timeout")
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = EventMan.song
	$AudioStreamPlayer.play()

func completed_build():
	return
