extends Node

export var flag_to_check = ""
export var default = false
onready var flag: bool = PersistMan.get_key(flag_to_check, default)

func _ready():
	if flag:
		get_parent().show()
	else:
		get_parent().hide()
	pass # Replace with function body.
