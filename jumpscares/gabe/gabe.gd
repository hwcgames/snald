extends BaseJumpscare

func _ready():
	$Timer.start()
	yield($Timer, "timeout")
	$Timer.stop()
	emit_signal("finished", true)
