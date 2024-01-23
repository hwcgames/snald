extends Control

export var now = false;

onready var player = $AnimationPlayer

func _ready():
	if not PersistMan.get_key("n1"):
		return
	$Timer.connect("timeout", self, "roll")
	$Timer.wait_time = 60
	roll()

func _physics_process(_delta):
	if now:
		go()
		now = false

func roll():
	randomize()
	if rand_range(0, 20) < 1:
		go()
	$Timer.start()

func go():
	visible = true
	player.play("peek")
	yield(get_tree().create_timer(7), "timeout")
	player.play("withdraw")
	yield(player, "animation_finished")
	visible = false
