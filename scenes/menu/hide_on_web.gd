extends Node

export var negate = false

func _ready():
	if LevelLoader.prebuilt != negate:
		get_parent().hide()
	elif negate:
		get_parent().show()
	pass # Replace with function body.
