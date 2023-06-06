extends Node
class_name PhoneAudio

var active = false

export var ringer_path = "res://music/ringer.ogg"
export var night_paths = ["res://music/phone/n1.mp3", "res://music/phone/n2.mp3", "res://music/phone/n3.mp3", "res://music/phone/n4.mp3", "res://music/phone/n5.mp3"]
export var hangup_path = "res://music/hangup.ogg"
export var funny = false
onready var player = AudioStreamPlayer.new()
onready var level = $"../QodotMap"
onready var ringer = load(ringer_path)
onready var hangup = load(hangup_path)
onready var night = load(night_paths[EventMan.night_index]) if EventMan.night_index < len(night_paths) else null

# Called when the node enters the scene tree for the first time.
func _ready():
	if (EventMan.funny_mode() != funny) or (night == null):
		player.remove_and_skip()
		call_deferred("remove_and_skip")
		return
	add_child(player)
	yield(level, "build_complete")
	player.stream = ringer
	player.play()
	yield(player, "finished")
	player.stream = night
	player.play()
	yield(player, "finished")
	player.stream = hangup
	player.play()
	yield(player, "finished")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
