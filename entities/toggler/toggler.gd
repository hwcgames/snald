extends QodotEntity

var in_circuit = ""
var out_circuit = ""
var out_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	in_circuit = properties["in_circuit"] if "in_circuit" in properties else in_circuit
	out_circuit = properties["out_circuit"] if "out_circuit" in properties else out_circuit
	$"/root/EventMan".connect("on", self, "on")

func on(name: String):
	if name == in_circuit:
		out_state = !out_state
		$"/root/EventMan".call("circuit_on" if out_state else "circuit_off", out_circuit)
