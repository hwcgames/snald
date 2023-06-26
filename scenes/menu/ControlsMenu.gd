extends VBoxContainer

var control_button = preload("res://scenes/menu/control_remapping_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for action in InputMap.get_actions():
		var box = HBoxContainer.new()
		var label = Label.new()
		label.text = action
		var button = control_button.instance()
		button.action = action
		box.add_child(label)
		box.add_child(button)
		add_child(box)
	pass # Replace with function body.
