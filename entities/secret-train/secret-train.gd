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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
