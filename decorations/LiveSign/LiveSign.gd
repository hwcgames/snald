extends Spatial

onready var circuit = self.get_meta("circuit", "default");
onready var on_mat = $Text.get_active_material(0)
onready var off_mat = $Sphere.get_active_material(0)
onready var text = $Text

func _ready():
	call_deferred("off", circuit)

func on(c):
	if c == circuit:
		text.material_override = on_mat

func off(c):
	if c == circuit:
		text.material_override = off_mat
