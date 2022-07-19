extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var collection_flag

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	collection_flag = properties["collection_flag"]
	var angle = properties["angle"]
	var target_nights = properties["nights"].split(",")
	var start_times = properties["start_times"].split(",")
	var end_times = properties["end_times"].split(",")
	rotation_degrees.y = angle
	var already_unlocked = PersistMan.persistent_dict[collection_flag]
	if already_unlocked:
		hide()
	pass # Replace with function body.

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		PersistMan.persistent_dict[collection_flag] = true
	remove_visitor(self)
	pass # Replace with function body.

func remove_visitor(n: Node):
	for i in n.get_children():
		remove_visitor(i)
	n.remove_and_skip()
