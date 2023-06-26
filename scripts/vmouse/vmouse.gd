extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const POINTER = preload("res://scripts/vmouse/Pointer.tscn")
var mouse_pos_dirty = true
var dpad_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(POINTER.instance())
	$Pointer.hide()
	var _drop = get_viewport().connect("size_changed", self, "reset_mouse")
	_drop = $"/root/EventMan".connect("off", self, "off")
	off("player_camera_pad")
	pass # Replace with function body.

func reset_mouse():
	$Pointer.transform.origin = get_viewport().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_tree().current_scene is Control or $"/root/EventMan".circuit("player_camera_pad") and $"/root/PersistMan".get_key("controller_mode"):
		var movement = Vector2.ZERO
		movement.x += Input.get_action_strength("vmouse_right")-Input.get_action_strength("vmouse_left")
		movement.y += Input.get_action_strength("vmouse_down")-Input.get_action_strength("vmouse_up")
		if get_tree().current_scene is Control or dpad_mode:
			movement.x += Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
			movement.y += Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
		movement *= 5
		
		var mouse_pos = $Pointer.transform.origin;
		mouse_pos += movement;
		mouse_pos_dirty = movement != Vector2.ZERO;
		var input_pos = OS.window_size * mouse_pos / get_viewport().size
		if mouse_pos_dirty:
			$Pointer.visible = true
			$Pointer.transform.origin.x = min(max(0, mouse_pos.x), get_viewport().size.x)
			$Pointer.transform.origin.y = min(max(0, mouse_pos.y), get_viewport().size.y)
			
			var input_event = InputEventMouseMotion.new()
			input_event.global_position = input_pos
			Input.parse_input_event(input_event)
		if Input.is_action_just_pressed("vmouse_click"):
			print("click!")
			var input_event = InputEventMouseButton.new()
			input_event.pressed = true
			input_event.global_position = input_pos
			input_event.button_index = BUTTON_LEFT
			Input.parse_input_event(input_event)
		if Input.is_action_just_released("vmouse_click"):
			var input_event = InputEventMouseButton.new()
			input_event.pressed = false
			input_event.global_position = input_pos
			input_event.button_index = BUTTON_LEFT
			Input.parse_input_event(input_event)
#		# Get screen position of viewport corner
#		var v_center = get_viewport().get_visible_rect().size / 2;
#		var pos_v = $Pointer.transform.origin - v_center;
#		var scale = get_viewport().get_visible_rect().size / OS.get_real_window_size()
#		pos_v /= max(scale.x, scale.y)
#		var w_center = OS.get_real_window_size() / 2
#		if movement != Vector2.ZERO:
#			mouse_pos_dirty = true
#			$Pointer.show()
#			$Pointer.transform.origin += movement
#			$Pointer.transform.origin.x = min(max(0, $Pointer.transform.origin.x), get_viewport().size.x)
#			$Pointer.transform.origin.y = min(max(0, $Pointer.transform.origin.y), get_viewport().size.y)
#			var input_event = InputEventMouseMotion.new()
#
#
#			input_event.position = w_center + pos_v
#			input_event.relative = movement
#
#			Input.parse_input_event(input_event)
#			Input.warp_mouse_position(w_center + pos_v)
#		if Input.is_action_just_pressed("vmouse_click"):
#			print("click!")
#			var input_event = InputEventMouseButton.new()
#			input_event.pressed = true
#			input_event.position = get_viewport().get_mouse_position()
#			input_event.button_index = 1
#			Input.parse_input_event(input_event)
#			input_event.pressed = false
#			Input.call_deferred("parse_input_event", input_event)
	else:
		$Pointer.hide()

func off(c):
	if c == "player_camera_pad" and mouse_pos_dirty:
		Input.warp_mouse_position(get_viewport().size / 2)
		mouse_pos_dirty = false
