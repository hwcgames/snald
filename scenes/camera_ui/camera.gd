extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_id = "set-me"

# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")

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
	for i in get_tree().get_nodes_in_group("camera"):
		if i.properties["camera_id"] == camera_id:
			get_node("../../../TabletScreenBase/CameraViewport").apply_camera(i)
