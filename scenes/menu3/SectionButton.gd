extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var target_tab = 0;

onready var tabs: TabContainer = find_tabs(self)

func find_tabs(node: Node):
	if node == null:
		return null
	if node is TabContainer:
		return node
	return find_tabs(node.get_parent())

func _pressed():
	tabs.current_tab = target_tab
