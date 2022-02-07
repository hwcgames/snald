extends QodotEntity


func _ready():
	var _err = connect("input_event", self, "on_input_event")

func on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.pressed:
			$"/root/EventMan".circuit_on(properties["circuit"])
		else:
			$"/root/EventMan".circuit_off(properties["circuit"])
