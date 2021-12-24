extends QodotEntity


func _ready():
	connect("input_event", self, "on_input_event")

func on_input_event(camera, event, click_position, click_normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.pressed:
			$"/root/EventMan".circuit_on(properties["circuit"])
		else:
			$"/root/EventMan".circuit_off(properties["circuit"])
