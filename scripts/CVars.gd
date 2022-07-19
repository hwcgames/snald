extends Node

# This file contains the cvar tables.

var ints: Dictionary = Dictionary()
var floats: Dictionary = Dictionary()
var bools: Dictionary = Dictionary()

func _ready():
	ints = Dictionary()
	floats = Dictionary()
	bools = Dictionary()
	var d = Directory.new()
	d.open("res://cvars")
	d.list_dir_begin(true, true)
	var cvar_files = []
	var file_name = d.get_next()
	while file_name != "":
		cvar_files.append("res://cvars/" + file_name)
		file_name = d.get_next()
	cvar_files.sort()
	for i in cvar_files:
		apply_cvars(i)

func apply_cvars(path: String):
	print("Loading cvars from "+ path)
	var cvars: StoredCVars = load(path)
	for i in cvars.ints.keys():
		ints[i] = cvars.ints[i]
	for i in cvars.floats.keys():
		floats[i] = cvars.floats[i]
	for i in cvars.bools.keys():
		bools[i] = cvars.bools[i]

func get_int(key: String) -> int:
	if not ints.has(key):
		print("WARN: Attempted to get missing int")
	var value: int = ints[key] as int;
	return value

func set_int(key: String, value: int):
	ints[key] = value

func get_float(key: String) -> float:
	if not floats.has(key):
		print("WARN: Attempted to get missing float")
	var value: float = floats[key] as float;
	return value

func set_float(key: String, value: float):
	floats[key] = value
