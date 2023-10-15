extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	var nights = ["n1", "n2", "n3", "n4", "n5"]
	for night_index in range(5):
		if PersistMan.get_key(nights[night_index]):
			pass
