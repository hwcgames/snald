extends QodotEntity

var save_flag: String
var sound: AudioStream
var text: String

func _ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties.get("angle", 0)
	var name = properties.get("name", "error")
	save_flag = properties.get("save_flag", "oopsie_daisy")
	if (not OS.is_debug_build()) and (not save_flag == "oopsie_daisy") and PersistMan.get_key(save_flag):
		return
	var scene: EasterEgg = load("res://eggs/trains/"+name+"/"+name+".tscn").instance()
	if "sound" in scene:
		sound = scene.get("sound")
	if "text" in scene:
		text = scene.get("text")
	add_child(scene)
	scene.connect("got", self, "got")

func got():
	PersistMan.set_flag(save_flag, true)
	PersistMan.save_game()
	var player = AudioStreamPlayer.new()
	add_child(player)
	if not sound == null:
		player.stream = sound
		player.play()
	var blocker = CutsceneMan.add_child(CutsceneMan.cutscene_blocker.instance()) if not CutsceneMan.cutscene_is_running() else CutsceneMan.get_node("Blocker");
	yield(CutsceneMan.remove_text("egg_get"), "completed")
	if not text == null:
		CutsceneMan.put_text(text, Vector2(0.5,0.1), 0.01, true, "egg_get")
	if not sound == null:
		yield(player, "finished")
	var timer = Timer.new()
	timer.wait_time = 2.0
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.remove_and_skip()
	if not text == null:
		yield(CutsceneMan.remove_text("egg_get"), "completed")
	player.remove_and_skip()
	if len(CutsceneMan.get_node("Blocker").get_children()) == 0:
		CutsceneMan.stop_cutscene()
	
