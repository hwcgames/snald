extends QodotEntity


func _ready():
	yield(get_parent(), "build_complete")
	var _err = connect("input_event", self, "on_input_event")
	_err = connect("mouse_exited", self, "on_mouse_leave")
	add_to_group("button")

func on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if CutsceneMan.player_cutscene_mode:
		return
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.pressed:
			$"/root/EventMan".circuit_on(properties["circuit"])
		else:
			$"/root/EventMan".circuit_off(properties["circuit"])

func on_mouse_leave():
	if CutsceneMan.player_cutscene_mode:
		return
	if EventMan.circuit(properties["circuit"]):
		$"/root/EventMan".circuit_off(properties["circuit"])
