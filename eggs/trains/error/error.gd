extends EasterEgg

var text = "whoops, that wasn't supposed to happen"

func _physics_process(delta):
	$Label3D.rotation_degrees.y += delta * 45
