extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var nights = CVars.get_table("nights")

# Called when the node enters the scene tree for the first time.
func _ready():
	for night_config in nights:
		var nc_table = CVars.get_table(night_config)
		var needs_flag = nc_table["needs_flag"] if "needs_flag" in nc_table else "none"
		if needs_flag != "none" and not PersistMan.get_key(needs_flag):
			continue
		var nc = preload("res://scenes/night_config/NightConfig.tscn").instance()
		for key in nc_table.keys():
			var value = nc_table[key]
			if key in ["song", "start_cutscene"] and value != null:
				value = load(value)
			if key in ["night_name", "needs_flag"]:
				continue;
			nc[key] = value
		var btn = Button.new()
		btn.text = nc_table["night_name"];
		btn.add_child(nc)
		btn.connect("pressed", nc, "run")
		add_child(btn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
