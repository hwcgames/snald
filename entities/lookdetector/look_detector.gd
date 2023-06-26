extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	player = get_tree().get_nodes_in_group("player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if player == null:
		return
	var c: Camera = player.get_node("Camera")
	var p = c.unproject_position(global_transform.origin) / get_viewport().size
	p = p.x
	if p < 0:
		p *= -1
	elif p > 1:
		p -= 1
	else:
		p = 0
	var active = p < properties["threshold"]
	if active and not EventMan.circuit(properties["circuit"]):
		EventMan.circuit_on(properties["circuit"])
	elif not active and EventMan.circuit(properties["circuit"]):
		EventMan.circuit_off(properties["circuit"])
#	pass
