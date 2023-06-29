extends QodotEntity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	rotation_degrees.y = properties["angle"] if "angle" in properties else 0
	rotation_degrees.x = properties["elevation"] if "elevation" in properties else 0
	scale.x = properties["width"] if "width" in properties else 1
	scale.y = properties["height"] if "height" in properties else 1
	call_deferred("pop_monitor_chars")
	EventMan.connect("on", self, "on")

func pop_monitor_chars():
	for character in get_tree().get_nodes_in_group("display_on_monitor"):
		var texturerect = TextureRect.new()
		texturerect.anchor_right = 1
		texturerect.anchor_bottom = 1
		texturerect.margin_right = 0
		texturerect.margin_bottom = 0
		texturerect.expand = true
		texturerect.stretch_mode = texturerect.STRETCH_SCALE
		var viewportt = character.get_node("display_on_monitor").get_texture()
		texturerect.texture = viewportt
		$Viewport/ParentForMonitorCharacters.add_child(texturerect)
	pass # Replace with function body.

func on(circuit):
	if circuit == "computer_restart":
		print("the computer is off now")
		
