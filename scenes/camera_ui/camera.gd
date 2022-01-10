extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_id = "set-me"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/EventMan".connect("on", self, "on")
	$"/root/EventMan".connect("off", self, "off")
	

func on(circuit: String):
	if circuit == "camera." + camera_id:
		for child in get_children():
			child.color.a = 1
func off(circuit: String):
	if circuit == "camera." + camera_id:
		for child in get_children():
			child.color.a = 0.3

func on_input_event(event):
	if event is InputEventMouseButton:
		print(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
