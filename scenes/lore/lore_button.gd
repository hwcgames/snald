extends Button

export var lore_scene: PackedScene
export var lore_parent_path: NodePath

func _pressed():
	for c in get_node(lore_parent_path).get_children():
		destroy_node(c)
	var s = lore_scene.instance()
	get_node(lore_parent_path).add_child(s)
	s.rect_min_size.x = get_node(lore_parent_path).rect_size.x

func destroy_node(node: Node):
	for c in node.get_children():
		destroy_node(c)
	node.remove_and_skip()
