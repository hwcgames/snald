extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const POINTER = preload("res://scripts/vmouse/Pointer.tscn")
var mouse_pos_dirty = true

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(POINTER.instance())
	$Pointer.hide()
	get_viewport().connect("size_changed", self, "reset_mouse")
	$"/root/EventMan".connect("off", self, "off")
	off("player_camera_pad")
	pass # Replace with function body.

func reset_mouse():
	$Pointer.transform.origin = get_viewport().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"/root/EventMan".circuit("player_camera_pad") and $"/root/PersistMan".get_key("controller_mode"):
		var movement = Vector2.ZERO
		movement.x += Input.get_axis("vmouse_left", "vmouse_right")
		movement.y += Input.get_axis("vmouse_up", "vmouse_down")
		movement *= 5
		if movement != Vector2.ZERO:
			mouse_pos_dirty = true
			$Pointer.show()
			$Pointer.transform.origin += movement
			$Pointer.transform.origin.x = min(max(0, $Pointer.transform.origin.x), get_viewport().size.x)
			$Pointer.transform.origin.y = min(max(0, $Pointer.transform.origin.y), get_viewport().size.y)
			var input_event = InputEventMouseMotion.new()
			input_event.position = $Pointer.transform.origin
			input_event.relative = movement
			Input.parse_input_event(input_event)
			Input.warp_mouse_position($Pointer.transform.origin)
		if Input.is_action_just_pressed("vmouse_click"):
			print("click!")
			var input_event = InputEventMouseButton.new()
			input_event.pressed = true
			input_event.position = $Pointer.transform.origin
			input_event.button_index = 1
			Input.parse_input_event(input_event)
			input_event.pressed = false
			Input.call_deferred("parse_input_event", input_event)
	else:
		$Pointer.hide()

func off(c):
	if c == "player_camera_pad" and mouse_pos_dirty:
		Input.warp_mouse_position(get_viewport().size / 2)
		mouse_pos_dirty = false
