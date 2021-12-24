extends Node

var counting = false
var timer = 0

func start():
	timer = 0
	var timer = load("res://eggs/speedrun_timer.tscn")
	counting = true
	if get_child_count() == 0:
		add_child(timer.instance())

func _process(delta):
	if counting:
		timer += 1
		$Control/Timer.text = str(floor(timer))
