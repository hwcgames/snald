extends QodotEntity

var CAMERA = preload("res://scenes/camera_ui/camera_ui.tscn")
onready var camera: Control = CAMERA.instance()
var min_angle = 0
var max_angle = 0
var turn_speed = 30
var primary_label = "Z/A"
var secondary_label = "X/B"
export var DEBUG = false

func _ready():
	add_to_group("player")
	yield(get_parent(), "build_complete")
	print("Set player angle to default")
	rotation_degrees.y = properties["angle"]
	min_angle = properties["min_angle"]
	max_angle = properties["max_angle"]
	turn_speed = float(properties["speed"])
	var _err = $"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	print("Bringing camera UI into tree")
	add_child(camera)
	print("Setting up jumpscare handler")
	_err = $"/root/EventMan".connect("jumpscare", self, "jumpscare")
func temperature_tick():
	if $"/root/EventMan".temperature <= 40:
		turn_speed = 60 - (50 - $"/root/EventMan".temperature)
	else:
		turn_speed = float(properties["speed"])
func _process(delta):
	# Get mouse X
	var mouse_x = get_viewport().get_mouse_position().x / get_viewport().size.x
	# Check whether the camera is bounded
	var left_bounded = rotation_degrees.y < min_angle and not DEBUG
	var right_bounded = rotation_degrees.y > max_angle and not DEBUG
	# Determine which direction to move
	var movement = 0.0
	if (mouse_x < 0.1 or Input.is_action_pressed("ui_left")) and not right_bounded and not $"/root/EventMan".circuit("player_camera_pad"):
		movement += 1
	if (mouse_x > 0.9 or Input.is_action_pressed("ui_right")) and not left_bounded and not $"/root/EventMan".circuit("player_camera_pad"):
		movement -= 1
	# Move
	rotation_degrees.y += movement * delta * turn_speed
	# 
#	# Debug move
#	if Input.is_key_pressed(KEY_PAGEDOWN):
#	# Debug reload map
#	if DEBUG and Input.is_key_pressed(KEY_R):
	if DEBUG and (Input.is_key_pressed(KEY_W) or Input.is_action_pressed("ui_up")) and not $"/root/EventMan".circuit("player_camera_pad"):
		translate(Vector3.FORWARD * delta * -5)
	if DEBUG and (Input.is_key_pressed(KEY_S) or Input.is_action_pressed("ui_down")) and not $"/root/EventMan".circuit("player_camera_pad"):
		translate(Vector3.FORWARD * delta * 5)
	if DEBUG and (Input.is_key_pressed(KEY_PAGEDOWN) and not $"/root/EventMan".circuit("player_camera_pad")):
		translate(Vector3.UP * delta * -5)
	if DEBUG and (Input.is_key_pressed(KEY_PAGEUP) and not $"/root/EventMan".circuit("player_camera_pad")):
		translate(Vector3.UP * delta * 5)
	if $"/root/PersistMan".get_key("controller_mode") and not $"/root/EventMan".circuit("player_camera_pad"):
		# Process controller buttons
		process_buttons()

func enable_debug():
	DEBUG = true
	$SpotLight.light_energy = 1.0
	$SpotLight.spot_range = 1000

func jumpscare(character: String, scene: String):
	if DEBUG:
		print("DIE FROM " + character + " WITH ANIMATION " + scene)
		return # Don't allow the player to die in debug mode
	var file = File.new()
	var path = "res://jumpscares/"+character+"/"+scene+".tscn"
	var jumpscare_packed
	if file.file_exists(path):
		jumpscare_packed = load(path)
	else:
		jumpscare_packed = load("res://jumpscares/dummy/dummy.tscn")
	var jumpscare = jumpscare_packed.instance()
	$JumpscareRoot.add_child(jumpscare)
	yield(jumpscare, "finished")
	var kill_player = jumpscare.kill_player
	path = "res://jumpscares/"+character+"/"+scene+"_dead.tscn"
	if kill_player:
		if file.file_exists(path):
			var _err = get_tree().change_scene(path)
		else:
			var _err = get_tree().change_scene("res://jumpscares/dummy/dummy_dead.tscn")

var last_primary_on = null
var last_secondary_on = null

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
		var screen = $Camera.unproject_position(primary_node.global_transform.origin)
		var label = Label.new()
		label.text = primary_label
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical = Control.GROW_DIRECTION_BOTH
		$ButtonLabelsParent.add_child(label)
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
		var screen = $Camera.unproject_position(secondary_node.global_transform.origin)
		var label = Label.new()
		label.text = secondary_label
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical = Control.GROW_DIRECTION_BOTH
		$ButtonLabelsParent.add_child(label)
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
		$"/root/EventMan".circuit_off(last_primary_on.properties["circuit"])
		last_primary_on = null
	if last_secondary_on is QodotEntity and last_secondary_on != secondary_node:
		$"/root/EventMan".circuit_off(last_secondary_on.properties["circuit"])
		last_secondary_on = null

