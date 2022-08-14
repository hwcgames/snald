extends EasterEgg

var text = "whoops, that wasn't supposed to happen"

func _process(delta):
	$Label3D.rotation_degrees.y += delta * 45
