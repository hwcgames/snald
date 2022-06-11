extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_id = "set-me"

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("push_camera_selection", self, "push_camera_selection")

func on(circuit: String):
	if circuit == "camera." + camera_id:
		for child in get_children():
			if child is Polygon2D:
				child.color.a = 1
func off(circuit: String):
	if circuit == "camera." + camera_id:
		for child in get_children():
			if child is Polygon2D:
				child.color.a = 0.3
func on_input_event(event):
	if event is InputEventMouseButton:
		print(event)

func _pressed():
	if not CutsceneMan.player_cutscene_mode:
		apply()

func apply():
	for i in get_tree().get_nodes_in_group("camera"):
		if i.properties["camera_id"] == camera_id:
			get_node("../../../TabletScreenBase/ViewportContainer/Viewport/CameraViewport").apply_camera(i)

func push_camera_selection(id: String):
	if id == camera_id:
		apply()
