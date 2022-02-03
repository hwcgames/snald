extends QodotEntity

var always_on = false
var circuit = ""
var material = ""
var on_now = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set angle correctly
	yield(get_parent(), "build_complete")
	$"/root/EventMan".connect("on", self, "circuit_on")
	$"/root/EventMan".connect("off", self, "circuit_off")
	on_now = (properties["always_on"] == 1) if "always_on" in properties else false
	always_on = (properties["always_on"] == 1) if "always_on" in properties else false
	circuit = properties["circuit"] if "circuit" in properties else ""
	$emitter.process_material = load (properties["material"])
	$emitter.lifetime = properties["lifetime"] if "lifetime" in properties else 3
	$emitter.amount = properties["amount"] if "amount" in properties else 8
	$emitter.randomness = properties["randomness"] if "randomness" in properties else 0
	$emitter.one_shot = properties["one_shot"] if "one_shot" in properties else 0
	$emitter.explosiveness = properties["explosiveness"] if "explosiveness" in properties else 0
	$emitter.draw_pass_1 = load (properties["drawpass"])

func circuit_on(name):
	if circuit != "" and name == circuit:
		$emitter.emitting = true

func circuit_off(name):
	if circuit != "" and name == circuit:
		$emitter.emitting = true
