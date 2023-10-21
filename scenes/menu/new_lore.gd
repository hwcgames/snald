extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_lore = false
	var lore_entries = CVars.get_table("lore_entries");
	for key in lore_entries.keys():
		var lore = lore_entries[key]
		var needs_flag = lore.needs_flag if "needs_flag" in lore else "none";
		if (needs_flag == "none" or PersistMan.get_key(lore.needs_flag)) and not PersistMan.get_key("lore_seen_"+key):
			new_lore = true
			break
	if new_lore:
		add_child(timer)
		timer.connect("timeout", self, "go")
		timer.start(1)
	else:
		queue_free()


func go():
	timer.start(1)
	self.modulate.a = 1 - self.modulate.a
