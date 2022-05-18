extends CheckBox

export var flag = "controller_mode"
export var default = false

func _ready():
	self.pressed = $"/root/PersistMan".persistent_dict[flag] if flag in PersistMan.persistent_dict else default

func _toggled(button_pressed):
	$"/root/PersistMan".persistent_dict[flag] = button_pressed
	$"/root/PersistMan".save_game()
