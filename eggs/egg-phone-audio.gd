extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active = false

export var ringer_path = "res://eggs/phone/ring.mp3"
export var night_paths = ["res://eggs/phone/n1.mp3", "res://eggs/phone/n2.mp3", "res://eggs/phone/n3", "res://eggs/phone/n4.mp3", "res://eggs/phone/n5.mp3", "res://eggs/phone/n6.mp3"]
onready var player = $AudioStreamPlayer
onready var level = $"../QodotMap"
onready var ringer = load(ringer_path)
onready var night = load(night_paths[EventMan.night_index])

# Called when the node enters the scene tree for the first time.
func _ready():
	# Determine whether it is April 1st
	var today = OS.get_datetime()
	var day = today["day"]
	var month = today["month"]
	active = day == 1 and month == 4
	if not active:
		player.remove_and_skip()
		call_deferred("remove_and_skip")
		return
	yield(level, "build_complete")
	player.stream = ringer
	player.play()
	yield(player, "finished")
	print("April fools!")
	player.stream = night
	player.play()
	yield(player, "finished")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
