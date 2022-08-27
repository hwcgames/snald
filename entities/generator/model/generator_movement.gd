extends Spatial

export var active = false

export var energy = 0.0
export var gear_speed = 360.0

onready var gears = $Gears.get_children()

func _ready():
	energy = 0
	$OmniLight.light_energy = 0

func _process(delta):
	if not $Cylinder001:
		return
	# Turn gears
	for gear in gears:
		gear = gear as Spatial
		gear.rotation_degrees.x += delta * gear_speed * energy
	# Set light emission
	var mat = $Cylinder001.mesh.surface_get_material(0)
	mat.emission_energy = lerp(mat.emission_energy, energy, delta / 2)
	$Cylinder001.mesh.surface_set_material(0, mat)
	$OmniLight.light_energy = lerp($OmniLight.light_energy / 3, energy, delta / 2) * 3
	# Energy decay
	if active:
		energy = lerp(energy, 0, delta * 2)
	pass

onready var t: Tween = $Tween

func on():
	active = true
	t.stop_all()
	t.interpolate_property($Lever, "rotation_degrees/z", $Lever.rotation_degrees.z, -90, 1.0)
	t.start()
	pass

func off():
	active = false
	t.stop_all()
	t.interpolate_property($Lever, "rotation_degrees/z", $Lever.rotation_degrees.z, 0, 1.0)
	t.start()
	pass
