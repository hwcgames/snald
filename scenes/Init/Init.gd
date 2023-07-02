extends Node

export var menu_path = "res://scenes/menu/menu.tscn"

func put_line(text: String):
	var label = preload("res://scenes/Init/label.tscn").instance()
	label.text = text
	$"%TextDisplay".add_child(label)

func _ready():
	# Skip intro when in editor
	if OS.is_debug_build() and not CVars.get_bool("force_opening"):
		print("Skip intro")
		get_tree().change_scene(menu_path)
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(1.5), "timeout")
	put_line("")
	put_line("HANDLE WITH CARE PROJECT 0")
	yield(get_tree().create_timer(0.1), "timeout")
	put_line("sNaldT KERNEL READY")
	yield(get_tree().create_timer(0.1), "timeout")
	$"%TextDisplay".add_child(preload("res://scenes/Init/splash.tscn").instance())
	put_line("(press any key to skip)")
	yield(get_tree().create_timer(1), "timeout")
	put_line("BEGIN SELF-TEST...")
	$"%ShaderCube".show()
	yield(shader_warm_visitor("res://textures/"), "completed")
	yield(shader_warm_visitor("res://animatronics/"), "completed")
	yield(shader_warm_visitor("res://decorations/"), "completed")
	yield(shader_warm_visitor("res://entities/"), "completed")
	yield(shader_warm_visitor("res://music/"), "completed")
	yield(get_tree().create_timer(0.5), "timeout")
	put_line("SELF-TEST SUCCESSFUL")
	yield(get_tree().create_timer(0.1), "timeout")
	$GSplash.show()
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db", 0, -32, 1.0)
	$Tween.start()
	var asp: AudioStreamPlayer = AudioStreamPlayer.new()
	$"/root".add_child(asp)
	asp.connect("finished", asp, "queue_free")
	asp.stream = load("res://music/boot.wav")
	asp.play()
	yield(get_tree().create_timer(1), "timeout")
	$AudioStreamPlayer.stop()
	get_tree().change_scene(menu_path)

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene(menu_path)

func _process(_delta):
	$ScrollContainer.scroll_vertical = 99999999999999

func shader_warm_visitor(path: String):
	var ls = Directory.new()
	ls.open(path)
	ls.list_dir_begin(true)
	var name = ls.get_next()
	while name != "":
		if ls.current_is_dir():
			yield(shader_warm_visitor(path + name + '/'), "completed")
		if not (name.ends_with(".material") or name.ends_with(".tres") or name.ends_with(".glb") or name.ends_with(".png") or name.ends_with(".jpg") or name.ends_with(".jpeg")):
			name = ls.get_next()
			continue
		var loading = ResourceLoader.load_interactive(path + name)
		if loading == null:
			name = ls.get_next()
			continue
		for stage in range(loading.get_stage_count()):
			loading.poll()
			yield(get_tree(), "idle_frame")
		var resource = loading.get_resource()
		if resource is Material:
			$"%ShaderCube".material_override = resource
		if resource is Material or resource is Texture:
			put_line(name + " OK")
		yield(get_tree(), "idle_frame")
		name = ls.get_next()
	yield(get_tree(), "idle_frame")
