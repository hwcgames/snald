extends StaticBody

export var boops: PoolStringArray

func _ready():
	pass # Replace with function body.

func on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if CutsceneMan.player_cutscene_mode:
		return
	var mouse_click = event as InputEventMouseButton
	if mouse_click:
		if mouse_click.pressed:
			$"../boop".stop()
			$"../boop".stream = load(boops[rand_range(0, len(boops))])
			$"../boop".play()
