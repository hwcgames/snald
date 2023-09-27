extends Label

func _ready():
	text = ""
	if PersistMan.get_key("cheater"):
		text += 'Cheats have been used\n'
	if PersistMan.get_key("developer"):
		text += 'Developer mode enabled\n'
	if len(Modloader.mods) > 0:
		text += str(len(Modloader.mods)) + ' mods loaded:\n'
		for mod in Modloader.mods:
			text += '- ' + mod + '\n'
	pass # Replace with function body.
