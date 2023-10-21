extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var lore_entries = CVars.get_table("lore_entries");
	for key in lore_entries.keys():
		var lore = lore_entries[key]
		var needs_flag = (lore.needs_flag != "none") if "needs_flag" in lore else false;
		if (not needs_flag) or PersistMan.get_key(lore.needs_flag):
			var button = Button.new();
			button.text = key;
			button.connect("pressed", self, "switch_lore", [key]);
			add_child(button)
	pass # Replace with function body.

func switch_lore(key):
	var lore = CVars.get_table("lore_entries")[key]
	for child in $"%LoreContainer".get_children():
		destroy_node(child)
	var lore_scene = load(lore.path)
	PersistMan.set_flag("lore_seen_"+key, true)
	var s = lore_scene.instance()
	$"%LoreContainer".add_child(s)

func destroy_node(node: Node):
	for c in node.get_children():
		destroy_node(c)
	node.remove_and_skip()
