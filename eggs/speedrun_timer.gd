extends Node

var counting = false
var timer = 0

func _ready():
	set_process(false)

func start():
	timer = 0
	var timer_ = load("res://eggs/speedrun_timer.tscn")
	counting = true
	set_process(true)
	if get_child_count() == 0:
		add_child(timer_.instance())

func _physics_process(_delta):
	if counting:
		timer += 1
		$Control/Timer.text = str(floor(timer))
