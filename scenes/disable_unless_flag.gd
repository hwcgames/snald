extends Node

export var flag_to_check = ""
export var default = false
onready var flag: bool = $"/root/PersistMan".persistent_dict[flag_to_check] if flag_to_check in $"/root/PersistMan".persistent_dict else default

func _ready():
	if flag:
		get_parent().show()
	else:
		get_parent().hide()
	pass # Replace with function body.
