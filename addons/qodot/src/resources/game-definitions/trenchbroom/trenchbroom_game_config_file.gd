class_name TrenchBroomGameConfigFile
extends Resource
tool

export(bool) var export_file : bool setget set_export_file
export(String, FILE, GLOBAL, "*.cfg") var target_file : String

export(String) var game_name := "Qodot"

export(Array, Resource) var brush_tags : Array = []
export(Array, Resource) var face_tags : Array = []
export(Array, Resource) var face_attrib_surface_flags : Array = []
export(Array, Resource) var face_attrib_content_flags : Array = []

export(Array, String) var fgd_filenames : Array = []

func gen_content(name: String, entities: Array, brushes: Array, brushfaces: Array, surfaceflags: Array, contentflags: Array):
	return {
		"version": 8,
		"name": name,
		"icon": "Icon.png",
		"fileformats": [
			{ "format": "Standard", "initialmap": "initial_standard.map" },
			{ "format": "Valve", "initialmap": "initial_valve.map" },
			{ "format": "Quake2", "initialmap": "initial_quake2.map" },
			{ "format": "Quake3" },
			{ "format": "Quake3 (legacy)" },
			{ "format": "Hexen2" },
			{ "format": "Daikatana" }
		],
		"filesystem": {
			"searchpath": ".",
			"packageformat": { "extension": "pak", "format": "idpak" }
		},
		"textures": {
			"root": "textures",
			"extensions": ["bmp", "exr", "hdr", "jpeg", "jpg", "png", "tga", "webp"],
			"attribute": "_tb_textures"
		},
		"entities": {
			"definitions": entities,
			"defaultcolor": "0.6 0.6 0.6 1.0",
			"modelformats": [ "mdl", "md2", "md3", "bsp", "dkm" ]
		},
		"tags": {
			"brush": brushes,
			"brushface": brushfaces,
		},
		"faceattribs": {
			"surfaceflags": surfaceflags,
			"contentflags": contentflags
		}
	}

func set_export_file(new_export_file : bool = true) -> void:
	if new_export_file != export_file:
		if not Engine.is_editor_hint():
			return

		if not target_file:
			print("Skipping export: No target file")
			return

		print("Exporting TrenchBroom Game Config File to ", target_file)
		var file_obj := File.new()
		file_obj.open(target_file, File.WRITE)
		file_obj.store_string(build_class_text())
		file_obj.close()

func build_class_text() -> String:
	return JSON.print(gen_content(
		game_name,
		fgd_filenames,
		gen_tags(brush_tags),
		gen_tags(face_tags),
		gen_flags(face_attrib_surface_flags),
		gen_flags(face_attrib_content_flags)
	), "\t")

func gen_tags(tags: Array) -> Array:
	var out = []
	var match_flags = ["texture", "contentflag", "surfaceflag", "surfaceparm", "classname"]
	for tag in tags:
		var entry = {
			"name": tag.tag_name,
			"attribs": tag.tag_attributes,
			"match": match_flags[tag.tag_match_type],
			"pattern": tag.tag_pattern,
		}
		if tag.texture_name != "":
			entry["texture"] = tag.texture_name
		out.push_back(entry)
	return out

func gen_flags(flags: Array) -> Array:
	var out = []
	for flag in flags:
		var entry = {
			"name": flag.attrib_name,
			"description": flag.attrib_description
		}
		out.push_back(flag)
	return out
