extends Node

# This file contains the cvar tables.

var ints: Dictionary = Dictionary()
var floats: Dictionary = Dictionary()
var bools: Dictionary = Dictionary()
var tables: Dictionary = Dictionary()

func _ready():
	ints = Dictionary()
	floats = Dictionary()
	bools = Dictionary()
	tables = Dictionary()
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
	merge_dictionary(cvars.ints, ints)
	merge_dictionary(cvars.floats, floats)
	merge_dictionary(cvars.bools, bools)
	merge_dictionary(cvars.tables, tables)

func merge_dictionary(from: Dictionary, into: Dictionary):
	for key in from.keys():
		if not key in into:
			into[key] = from[key]
		elif typeof(into[key]) != typeof(from[key]):
			print('Error merging, incompatible types between ', into[key], ' and ', from[key])
		elif into[key] is Dictionary:
			merge_dictionary(from[key], into[key])
		elif into[key] is Array:
			for element in from[key]:
				into[key].push_back(element)
		else:
			into[key] = from[key]
func get_int(key: String) -> int:
	if not ints.has(key):
		print("WARN: Attempted to get missing int")
		return 0
	var value: int = ints[key] as int;
	return value

func set_int(key: String, value: int):
	ints[key] = value

func get_float(key: String) -> float:
	if not floats.has(key):
		print("WARN: Attempted to get missing float")
		return 0.0
	var value: float = floats[key] as float;
	return value

func set_float(key: String, value: float):
	floats[key] = value



func get_bool(key: String) -> bool:
	if not bools.has(key):
		print("WARN: Attempted to get missing bool")
		return false
	var value: bool = bools[key] as bool;
	return value

func set_bool(key: String, value: bool):
	bools[key] = value

func get_table(key: String) -> Dictionary:
	return tables.get(key)
