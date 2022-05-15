extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mods = []

# Called when the node enters the scene tree for the first time.
func _ready():
	reload();
	pass # Replace with function body.

func reload():
	Console.print("Loading mods.")
	var new_mods = []
	var d = Directory.new()
	d.open("./mods")
	d.list_dir_begin(true)
	while true:
		var f = d.get_next()
		if f == "":
			break
		if f.ends_with("pck"):
			Console.print("Found a new mod " + f)
			new_mods.append(f)
	d.list_dir_end()
	new_mods.sort()
	for new_mod in new_mods:
		Console.print("Loading " + new_mod)
		if not ProjectSettings.load_resource_pack(new_mod):
			Console.print("Loading " + new_mod + " failed...")
		else:
			if new_mod in mods:
				mods.remove(mods.find(new_mod))
			mods.append(new_mod)
	Console.print("Done loading mods!")
