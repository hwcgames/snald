extends QodotEntity

class_name Player

var CAMERA = preload("res://scenes/camera_ui/camera_ui.tscn")
onready var camera: Control = CAMERA.instance()
var min_angle = 0
var max_angle = 0
var limit_turns = true
var turn_speed = 30
var primary_label = "Z/A"
var secondary_label = "X/B"
var allow_camera = true
export var DEBUG = false
var dead

func _ready():
	if remove_if_unwanted():
		return
	set_physics_process(false)
	add_to_group("player")
	yield(get_parent(), "build_complete")
	if EventMan.circuit("test_mode"):
		set_physics_process(false)
		$Camera.current = false
		return
	print("Set player angle to default")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	min_angle = properties["min_angle"] if "min_angle" in properties else 0
	max_angle = properties["max_angle"] if "min_angle" in properties else 0
	turn_speed = float(properties["speed"] if "speed" in properties else turn_speed)
	limit_turns = properties["limit_turns"] == 1 if "limit_turns" in properties else limit_turns
	allow_camera = properties["allow_camera"] == 1 if "allow_camera" in properties else allow_camera
	$"%Flashlight".light_energy *= properties["has_flashlight"] if "has_flashlight" in properties else 0
	var _err = $"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	if allow_camera:
		print("Bringing camera UI into tree")
		add_child(camera)
	print("Setting up jumpscare handler")
	_err = $"/root/EventMan".connect("jumpscare", self, "jumpscare")
	EventMan.connect("reset", self, "reset")
	$Camera.current = true
	set_physics_process(true)

func remove_if_unwanted():
	if not CVars.get_bool("normal_player"):
		remove_visitor(self)
		return true

func reset():
	rotation_degrees.y = properties["angle"]
	turn_speed = float(properties["speed"] if "speed" in properties else turn_speed)
	$Camera.transform.origin = Vector3.ZERO

func temperature_tick():
	if $"/root/EventMan".temperature <= CVars.get_float("player_slow_threshold"):
		turn_speed = 60 - (50 - $"/root/EventMan".temperature)
	else:
		turn_speed = float(properties["speed"] if "speed" in properties else turn_speed)

func _physics_process(delta):
	# Get mouse X
	var mouse_x = get_viewport().get_mouse_position().x / get_viewport().size.x
	# Check whether the camera is bounded
	var left_bounded = rotation_degrees.y < min_angle and not DEBUG
	var right_bounded = rotation_degrees.y > max_angle and not DEBUG
	if not limit_turns:
		right_bounded = false
		left_bounded = false
	# Determine which direction to move
	var movement = 0.0
	if (mouse_x < 0.05 or Input.is_action_pressed("ui_left")) and not right_bounded and not $"/root/EventMan".circuit("player_camera_pad") and not CutsceneMan.player_cutscene_mode:
		movement += 1
	if (mouse_x > 0.95 or Input.is_action_pressed("ui_right")) and not left_bounded and not $"/root/EventMan".circuit("player_camera_pad") and not CutsceneMan.player_cutscene_mode:
		movement -= 1
	# Apply cutscene movement override
	if CutsceneMan.player_cutscene_mode:
		rotation_degrees.y = lerp(rotation_degrees.y, CutsceneMan.player_cutscene_goal, delta * 10)
	else:
		rotation_degrees.y += movement * delta * turn_speed
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
	if $"/root/PersistMan".get_key("controller_mode") and not $"/root/EventMan".circuit("player_camera_pad") and not CutsceneMan.player_cutscene_mode:
		# Process controller buttons
		process_buttons()
	move_flashlight_to_mouse()

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
	var jumpscare: Spatial = jumpscare_packed.instance()
	jumpscare.player = self
	if jumpscare.relative:
		$ViewportContainer/Viewport/JumpscareRoot.add_child(jumpscare)
	else:
		get_parent().add_child(jumpscare)
		jumpscare.global_transform.origin = global_transform.origin
		jumpscare.rotation_degrees.y = properties["angle"]
	yield(jumpscare, "finished")
	var kill_player = jumpscare.kill_player
	path = "res://jumpscares/"+character+"/"+scene+"_dead.tscn"
	remove_visitor(jumpscare)
	# Load the jumpscare scene
#	if kill_player:
#		if file.file_exists(path):
#			var _err = get_tree().change_scene(path)
#		else:
#			var _err = get_tree().change_scene("res://jumpscares/dummy/dummy_dead.tscn")
	if kill_player:
		var dead_scene: PackedScene
		if file.file_exists(path):
			dead_scene = load(path)
		else:
			dead_scene = load("res://jumpscares/dummy/dummy_dead.tscn")
		get_tree().paused = true
		dead = dead_scene.instance()
		add_child(dead)
		dead.connect("finished", self, "dead_screen_finished")

func remove_visitor(n: Node):
	for i in n.get_children():
		remove_visitor(i)
	n.remove_and_skip()

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

func dead_screen_finished(exit: bool):
	get_tree().paused = false
	if exit:
		EventMan.return_to_title()
	else:
		EventMan.quick_reset()
		remove_visitor(dead)

func move_flashlight_to_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var world_pos = $Camera.project_position(mouse_pos, 10)
	$"%Flashlight".look_at(world_pos, Vector3.UP)
