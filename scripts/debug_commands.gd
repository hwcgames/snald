extends Node

func _ready():
	Console.connect_node(self)

const cheater_cheater_pumpkin_eater_help = "With great power comes great responsibility... (Enables cheats.)"
func cheater_cheater_pumpkin_eater_cmd():
	PersistMan.persistent_dict["cheater"] = true
	EventMan.circuit_on("cheater")

const set_power_help = "Sets the power."
func set_power_cmd(power: float):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can break the laws of thermodynamics")
		return
	if power < 0 or 100 < power:
		Console.print("New power should be within [0,100].")
		return
	EventMan.power = power;
	Console.print("Ok")

const set_temperature_help = "Sets the temperature."
func set_temperature_cmd(temperature: float):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can break the laws of thermodynamics")
		return
	EventMan.temperature = temperature;
	Console.print("Ok")

const reset_help = "Creates a new universe where everything repeats itself, according to 「Fate」. (Resets the game's state.)"
func reset_cmd():
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can accelerate the universe to the 「Vanishing Point」")
		return
	EventMan.reset()
	Console.print("Ok")

const set_difficulty_help = "Makes a friend or foe ANGRY. Costs 5 JUICE. (Sets a character's anger level.)"
func set_difficulty_cmd(name: String, diff: int):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use mind control")
		return
	EventMan.register(name, diff)
	for character in get_tree().get_nodes_in_group("animatronics"):
		if character.id == name:
			character.difficulty = diff
	Console.print("Ok")

const push_state_help = "Teleports a character to the specified position."
func push_state_cmd(name: String, state: int):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use mind control")
		return
	for character in get_tree().get_nodes_in_group("animatronics"):
		if character.id == name:
			character.assume_state(state)
	Console.print("Ok")

const set_circuit_help = "Sets the value of a circuit."
func set_circuit_cmd(name: String, value: bool):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	if name == "cheater":
		Console.print(";)")
	if value:
		EventMan.circuit_on(name)
	else:
		EventMan.circuit_off(name)
	Console.print("Ok")

const circuit_help = "Gets the value of a circuit."
func circuit_cmd(name: String):
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	if not name in EventMan.circuit_states:
		Console.print("Doesn't exist yet.")
	else:
		Console.print(EventMan.circuit_states[name])

const circuits_help = "Gets the value of all circuits."
func circuits_cmd():
	if LevelLoader.map != null and not EventMan.circuit("cheater"):
		Console.print("Only cheaters can use electrokinesis")
		return
	Console.print(str(EventMan.circuit_states))

const set_saved_bool_help = "Sets a save file flag."
func set_saved_bool_cmd(name: String, value: bool):
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can change the past")
		return
	if name == "cheater":
		Console.print(";)")
	PersistMan.persistent_dict[name] = value

const saved_help = "Gets the save file."
func saved_cmd():
	Console.print(str(PersistMan.persistent_dict))

const free_help = "♪ You can scramble my molecules, 'Cause I'm just passin' through! ♪ (Enables noclip.)"
func free_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can ♪ scramble them molecules. ♪")
		return
	for player in get_tree().get_nodes_in_group("player"):
		player.enable_debug()
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.enable_debug()

const reload_help = "Travels between dimensions by being closed between two objects. (Reloads the map.)"
func reload_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can perform filthy acts at a reasonable price.")
		return
	get_tree().reload_current_scene()
	LevelLoader.load_level(LevelLoader.map)

const pause_help = "The ultimate stand. (Pauses and unpauses power, temperature, and character movements.)"
func pause_cmd():
	if not EventMan.circuit("cheater"):
		Console.print("Only cheaters can move during stopped time.")
		return
	EventMan.pause = not EventMan.pause

const maps_help = "Shows all maps included with the game."
func maps_cmd():
	var dir = Directory.new()
	var result = dir.open("maps");
	if result == OK:
		dir.list_dir_begin()
		var name = dir.get_next()
		while name != "":
			if not dir.current_is_dir() and not name.ends_with("import"):
				Console.print(name)
			name = dir.get_next()
	else:
		Console.print("heck")
		Console.print(result)

const mods_help = "Shows all mods that are currently loaded."
func mods_cmd():
	for mod in Modloader.mods:
		Console.print(mod)
