extends Player
class_name FreeRoamPlayer

var speed = 3.0
onready var raycast = $RayCast
onready var areacast = $AreaCast
var height = 2.5
var y_vel = 0.0

func _ready():
	speed = float(properties["move_speed"] if "move_speed" in properties else speed)

func _physics_process(delta):
	if not raycast.is_colliding():
		y_vel -= 1.0
		transform.origin.y += y_vel * delta
		return
	y_vel = 0
	var collision_height = (global_transform.origin - raycast.get_collision_point()).y
	var offset_height = height - collision_height
	global_transform.origin.y += offset_height
	
	# Apply cutscene movement override
	if not CutsceneMan.player_cutscene_mode:
		var move_axis = Input.get_axis("ui_down", "ui_up")
		(self as Object).move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * move_axis * speed)
