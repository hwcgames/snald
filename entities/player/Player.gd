extends QodotEntity

var CAMERA = preload("res://scenes/camera_ui/camera_ui.tscn")
onready var camera: Control = CAMERA.instance()
var min_angle = 0
var max_angle = 0
var turn_speed = 30
export var DEBUG = false

func _ready():
	yield(get_parent(), "build_complete")
	print("Set player angle to default")
	rotation_degrees.y = properties["angle"]
	min_angle = properties["min_angle"]
	max_angle = properties["max_angle"]
	turn_speed = float(properties["speed"])
	$"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	print("Bringing camera UI into tree")
	add_child(camera)
	print("Setting up jumpscare handler")
	$"/root/EventMan".connect("jumpscare", self, "jumpscare")
func temperature_tick():
	if $"/root/EventMan".temperature <= 50:
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
	if mouse_x < 0.1 and not right_bounded:
		movement += 1
	if mouse_x > 0.9 and not left_bounded:
		movement -= 1
	# Move
	rotation_degrees.y += movement * delta * turn_speed
	# Debug move
	if Input.is_key_pressed(KEY_PAGEDOWN):
		DEBUG = true
	if DEBUG and Input.is_key_pressed(KEY_W):
		translate(Vector3.FORWARD * delta * -5)

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
			get_tree().change_scene(path)
		else:
			get_tree().change_scene("res://jumpscares/dummy/dummy_dead.tscn")
