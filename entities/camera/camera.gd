extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera: Camera
var DEBUG = false
var angle = 0
var min_angle = 0
var max_angle = 0
var turn_speed = 10
var manual = false
var viewed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("camera")
	yield(get_parent(), "build_complete")
	camera = $Camera
	remove_child(camera)
	$Viewport.add_child(camera)
	camera = $"Viewport/Camera"
	rotation_degrees.x = properties["elevation"] if "elevation" in properties else -20
	angle = 180 + properties["angle"] if "angle" in properties else 0
	angle = fmod(angle + 360,360.0)
	rotation_degrees.y = angle
	if "min_angle" in properties and "max_angle" in properties:
		min_angle = angle + properties["min_angle"]
		max_angle = angle + properties["max_angle"]
	manual = (properties["rotates_manually"] == 1) if "rotates_manually" in properties else false
	camera.global_transform = global_transform
	pass # Replace with function body.

var movement_dir = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not viewed:
		return
	# Get mouse X
	var mouse_x = get_viewport().get_mouse_position().x / get_viewport().size.x
	# Check whether the camera is bounded
	var rot = camera.rotation_degrees.y
	if rot < 0:
		rot += 360.0
	var left_bounded = rot < min_angle and not DEBUG
	var right_bounded = rot > max_angle and not DEBUG
	# Determine which direction to move
	var movement = 0.0
	if manual:
		print(mouse_x)
		if (mouse_x < 0.1 or Input.is_action_pressed("ui_left")) and not right_bounded:
			movement += 1
		if (mouse_x > 0.9 or Input.is_action_pressed("ui_right")) and not left_bounded:
			movement -= 1
	elif min_angle && max_angle:
		if left_bounded or right_bounded:
			movement_dir *= -1
		movement = movement_dir
	# Move
	camera.rotation_degrees.y += movement * delta * turn_speed
	# Debug move
	if DEBUG and (Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up")) and $"/root/EventMan".circuit("player_camera_pad"):
		camera.translate(Vector3.FORWARD * delta * 5)
	if DEBUG and (Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down")) and $"/root/EventMan".circuit("player_camera_pad"):
		camera.translate(Vector3.FORWARD * delta * -5)
	if DEBUG and (Input.is_key_pressed(KEY_PAGEDOWN) and $"/root/EventMan".circuit("player_camera_pad")):
		camera.translate(Vector3.UP * delta * -5)
	if DEBUG and (Input.is_key_pressed(KEY_PAGEUP) and $"/root/EventMan".circuit("player_camera_pad")):
		camera.translate(Vector3.UP * delta * 5)
	if $"/root/PersistMan".get_key("controller_mode") and $"/root/EventMan".circuit("player_camera_pad"):
		# Process controller buttons
		process_buttons()

func enable_debug():
	DEBUG = true

var last_primary_on
var last_secondary_on
var primary_label = "Z/A"
var secondary_label = "X/B"

func process_buttons():
	for child in $ButtonLabelsParent.get_children():
		child.remove_and_skip()
	if $"/root/EventMan".circuit("player_camera_pad"):
		return
	var buttons = get_tree().get_nodes_in_group("button")
	var primary = 9999999
	var primary_node: Spatial = null
	var secondary = 9999999
	var secondary_node: Spatial = null
	for button in buttons:
		var position = global_transform.xform_inv(button.global_transform.origin)
		if position.z < abs(position.x):
			continue
		var distance = Vector2(abs(position.x), abs(position.y)).length()
		if distance < secondary:
			if distance < primary:
				primary_node = button
				primary = distance
			else:
				secondary_node = button
				secondary = distance
	if primary_node:
		var screen = $Viewport/Camera.unproject_position(primary_node.global_transform.origin)
		var label = Label.new()
		label.text = primary_label
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical = Control.GROW_DIRECTION_BOTH
		$Viewport/ButtonLabelsParent.add_child(label)
		label.margin_left = screen.x
		label.margin_right = screen.x
		label.margin_bottom = screen.y
		label.margin_top = screen.y
		if Input.is_action_pressed("ui_accept") and last_primary_on == null:
			$"/root/EventMan".circuit_on(primary_node.properties["circuit"])
			last_primary_on = primary_node
		if Input.is_action_just_released("ui_accept") and primary_node == last_primary_on:
			$"/root/EventMan".circuit_off(primary_node.properties["circuit"])
			last_primary_on = null
	if secondary_node:
		var screen = $Viewport/Camera.unproject_position(secondary_node.global_transform.origin)
		var label = Label.new()
		label.text = secondary_label
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical = Control.GROW_DIRECTION_BOTH
		$Viewport/ButtonLabelsParent.add_child(label)
		label.margin_left = screen.x
		label.margin_right = screen.x
		label.margin_bottom = screen.y
		label.margin_top = screen.y
		if Input.is_action_pressed("ui_cancel") and last_secondary_on == null:
			$"/root/EventMan".circuit_on(secondary_node.properties["circuit"])
			last_secondary_on = secondary_node
		if Input.is_action_just_released("ui_cancel") and secondary_node == last_secondary_on:
			$"/root/EventMan".circuit_off(secondary_node.properties["circuit"])
			last_secondary_on = null
	if last_primary_on is QodotEntity and last_primary_on != primary_node:
		last_primary_on = null
		$"/root/EventMan".circuit_off(last_primary_on.properties["circuit"])
	if last_secondary_on is QodotEntity and last_secondary_on != secondary_node:
		last_secondary_on = null
		$"/root/EventMan".circuit_off(last_secondary_on.properties["circuit"])
#	pass
