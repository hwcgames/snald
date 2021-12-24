extends QodotEntity

func get_angle():
	return properties["angle"] if "angle" in properties else 0

func get_animation():
	return properties["animation"] if "animation" in properties else "idle"

func get_animatronic():
	return properties["animatronic_id"] if "animatronic_id" in properties else "base"

func get_room():
	return properties["room_id"] if "room_id" in properties else "lobby"

func get_state():
	return properties["state_id"] if "state_id" in properties else 0

