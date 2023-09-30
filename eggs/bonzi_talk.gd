tool
extends TextureRect

var talking = false
var talk_interval = 0.1
export var talk_frames = PoolStringArray([])
export var talk_sounds = PoolStringArray([])
var talk_string = ""
var talk_position = 0
export var idle_tex: Texture
export var spooky_sound: AudioStream

const hints = [
	"My name's Arty Arry, you can click on me for \"hints\"!",
	"If you don't lose the game for six minutes, you win instead",
	"If you're having trouble on a level, try being good at the game",
	"Never give up, giving up is for losers",
	"Have you tried turning it off and on again?",
	"Make sure your computer is powered on before attempting night 4",
	"There's a secret phrase that you can use to get into the sound test screen",
	"There's a secret phrase that you can use to activate a speedrun timer",
	"If you hear a noise from the vent, it means someone's pointing a gun at you",
	"The gun can only shoot once because it's too big for normal clips",
	"After Lilac kills you, she installs an esoteric Linux distro on your computer",
	"A shadow demon stole the HVAC control board; can't have shit in detroit",
	"Every copy of SNALD is personalized, yours has a fat italian man that chases you down a hallway",
	"L isn't real 5664",
	"I thlammed my penith in the car door",
	"I'm making mac and cheese, and nobody can stop me!",
	"The restroom is still out of order, because Seargant put a pipe bomb in the toilet.",
	"The Hit Video Game Among Us",
	"You have to put the CD in your computer",
	"Malware spyware trojan, enter your computer",
	"If you let it get too hot, someone might go outside to cool off",
	"JOJO doesn't like to stay out in the open, watch for his menacing aura to predict his attacks",
	"Read any good books lately?",
	"Trains are cool. Click on them if you see one.",
	"Fork me on GitHub",
	"When I flex, I feel my best",
	"My thoughts will follow you into your dreams",
	"Trans rights are human rights",
	"Voting is the easiest way to stop the world from getting worse",
	"Did you know this game used to have lore? It was dumb but pretty funny. You see the story was a tragic one about dealing with grief, with a supernatural twist, very interesting! It all started a long time ago when",
	"Corrupt government buildings are gender-neutral bathrooms",
	"Kel from OMORI is the pinnacle of character design",
	"Polaris' favorite weapons are the ones that break the geneva convention!",
	"Florida Man teaches pet lizard to run on water, google Roko's Basilisk to learn more",
	"Gex",
	"1 hour of silence occasionally broken by Mario 64 Thwomp sound effect",
	"eval:special_gex()"
]

var spooky_hints = [
	"We're not sure how this will reach you but you've been in a coma for three weeks, please wake up - Mom",
	"The outside isn't",
	"The lights keep us safe",
	"What makes reality real",
	OS.get_environment("USERNAME") + ", I can't breathe",
	"I can't breathe",
	"Discord sex hack 2023 (real) (not clickbait)",
	"You just lost The Game",
	"Just pretend he isn't here"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Polygon2D.hide()
	texture.atlas = idle_tex
	pass # Replace with function body.
	hints.shuffle()

var talk_clock = 0.0

var counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	talk_clock += delta
	if talk_clock > talk_interval and talking:
		talk_clock = 0
		talk()
	if Engine.editor_hint:
		counter += 1
	if Engine.editor_hint and ((counter % 600) == 0):
		counter = 0
		talk_frames = PoolStringArray([])
		talk_sounds = PoolStringArray([])
		var dir = Directory.new()
		dir.open("res://scenes/menu/buddy/poses")
		dir.list_dir_begin(true, true)
		var next = "a"
		while next != "":
			next = dir.get_next()
			if not ("talk" in next and next.ends_with("png")):
				continue
			talk_frames.append("res://scenes/menu/buddy/poses/"+next)
		dir.list_dir_end()
		var dir2 = Directory.new()
		dir2.open("res://scenes/menu/buddy/sounds")
		dir2.list_dir_begin(true, true)
		next = "a"
		while next != "":
			next = dir2.get_next()
			if not (next.ends_with("ogg") and "talk" in next):
				continue
			talk_sounds.append("res://scenes/menu/buddy/sounds/"+next)
		dir2.list_dir_end()

func talk():
	$Polygon2D.show()
	$Timer.stop()
	$AudioStreamPlayer.stop()
	if talk_string in spooky_hints:
		$AudioStreamPlayer.stream = spooky_sound
		texture.atlas = load("res://scenes/menu/buddy/poses/spooky.png")
	else:
		texture.atlas = load(talk_frames[randi() % len(talk_frames)])
		$AudioStreamPlayer.stream = load(talk_sounds[randi() % len(talk_sounds)])
	$AudioStreamPlayer.play()
	talk_position += 2
	$Polygon2D/Label.text = talk_string
	$Polygon2D/Label.visible_characters = talk_position
	if talk_position >= len(talk_string):
		talking = false
		$Timer.start()
		texture.atlas = load("res://scenes/menu/buddy/poses/idle.png")
		yield($Timer, "timeout")
		$Polygon2D.hide()
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			talking = true
			talk_string = choose_string()
			if talk_string.begins_with("eval:"):
				var expr = Expression.new()
				expr.parse(talk_string.substr(5))
				talk_string = expr.execute([], self)
			talk_position = 0
			$Polygon2D.show()
	pass # Replace with function body.

var hint_cursor = 0

func choose_string():
	var spooky_roll = randi() % 20
	if spooky_roll == 13:
		return spooky_hints[randi() % len(spooky_hints)]
	else:
		if hint_cursor >= len(hints):
			hints.shuffle()
			hint_cursor = 0
		hint_cursor += 1
		return hints[hint_cursor-1]
	pass

func special_gex():
	if $"../Error".visible:
		return "I love gex!"
	else:
		return ":("
