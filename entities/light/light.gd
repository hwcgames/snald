extends QodotEntity
class_name SnaldLight

# config
var always_on = false
var circuit = ""
var flicker_below = 10.0
var flicker_chance = 0.01
var energy: float = 0.5
var power = 0.1

# runtime
var on_now = false
var flickering = false
var depleted = false
var goal_energy = energy
var hue = 0
var saturation = 0

func _ready():
	tween = Tween.new()
	add_child(tween)
	# Set angle correctly
	yield(get_parent(), "build_complete")
	var _err = $"/root/EventMan".connect("on", self, "circuit_on")
	_err = $"/root/EventMan".connect("off", self, "circuit_off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")
	on_now = (int(properties["always_on"]) == 1) if "always_on" in properties else false
	always_on = (int(properties["always_on"]) == 1) if "always_on" in properties else false
	circuit = properties["circuit"] if "circuit" in properties else ""
	flicker_below = properties["flicker_below"] if "flicker_below" in properties else 10.0
	flicker_chance = properties["flicker_chance"] if "flicker_chance" in properties else 0.01
	energy = float(properties["energy"]) if "energy" in properties else 0.5
	goal_energy = energy * (1 if on_now else 0)
	power = CVars.get_float(properties["power"]) if "power" in properties else CVars.get_float("default_light_power_consumption")
	hue = (float(properties["hue"]) / 360) if "hue" in properties else hue
	saturation = properties["saturation"] if "saturation" in properties else saturation
	$OmniLight.light_color = Color.from_hsv(hue, saturation, 1.0)
	$AudioStreamPlayer3D.stream = load(properties["buzz"]) if "buzz" in properties else null
	$OmniLight.omni_range = properties["radius"] if "radius" in properties else 16
	set_process(true)
	call_deferred("set_process", true)
	EventMan.connect("reset", self, "reset")
	if on_now:
		$OmniLight.light_energy = goal_energy
	else:
		$OmniLight.light_energy = 0

func reset():
	tween.remove_all()
	depleted = false
	on_now = (properties["always_on"] == 1) if "always_on" in properties else false
	goal_energy = energy * (1 if on_now else 0)
	$OmniLight.light_energy = goal_energy
	flickering = false

var lit = false
var tween: Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	$OmniLight.light_energy = lerp($OmniLight.light_energy, goal_energy, min(delta * 10, 1))
	if abs($OmniLight.light_energy - goal_energy) < 0.01 and not flickering:
		call_deferred("set_process", false)
	if flickering and on_now and not depleted:
		var rand = randf()
		if rand <= flicker_chance:
			tween.remove_all()
			tween.interpolate_property($OmniLight, "light_energy", 0, goal_energy, 1.0, Tween.TRANS_QUART, Tween.EASE_OUT)
			tween.start()
			$AudioStreamPlayer3D.stop()
			$AudioStreamPlayer3D.play()
	pass

func circuit_on(name):
	if circuit != "" and name == circuit and not depleted:
		set_process(true)
		on_now = true
		goal_energy = energy
		if "instant_on" in properties and properties["instant_on"] == 1 and $OmniLight.light_energy < 0.3:
			$AudioStreamPlayer3D.stop()
			$AudioStreamPlayer3D.play()
			$"/root/EventMan".power -= power
			$OmniLight.light_energy = goal_energy
		else:
			tween.remove_all()
			tween.interpolate_property($OmniLight, "light_energy", $OmniLight.light_energy, goal_energy, 0.25, Tween.TRANS_QUART, Tween.EASE_OUT)
			tween.start()

func circuit_off(name):
	if circuit != "" and name == circuit:
		set_process(true)
		on_now = false
		goal_energy = 0
		tween.remove_all()
		tween.interpolate_property($OmniLight, "light_energy", $OmniLight.light_energy, goal_energy, 1.0, Tween.TRANS_QUART, Tween.EASE_OUT)
		tween.start()

func power_tick():
	if on_now:
		$"/root/EventMan".power -= power
	if $"/root/EventMan".power <= 0:
		depleted = true
		circuit_off(circuit)
	if $"/root/EventMan".power < flicker_below:
		set_process(true)
		flickering = true
