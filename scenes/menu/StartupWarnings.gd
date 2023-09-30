extends Label

func _ready():
	text = ""
	if PersistMan.persistent_dict["cheater"]:
		text += 'Cheats have been used\n'
	if PersistMan.persistent_dict["developer"]:
		text += 'Developer mode enabled\n'
	if OS.is_debug_build():
		text += 'Debug\n'
	if len(Modloader.mods) > 0:
		text += str(len(Modloader.mods)) + ' mods loaded:\n'
		for mod in Modloader.mods:
			text += '- ' + mod + '\n'
	pass # Replace with function body.
