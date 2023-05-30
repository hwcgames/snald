extends QodotEntity

var in_circuit = ""
var out_circuit = ""
var out_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_parent(), "build_complete")
	in_circuit = properties["in_circuit"] if "in_circuit" in properties else in_circuit
	out_circuit = properties["out_circuit"] if "out_circuit" in properties else out_circuit
	if (int(properties["starts_on"])>0) if "starts_on" in properties else false:
		out_state = true
		$"/root/EventMan".circuit_on(out_circuit)
	var _err = $"/root/EventMan".connect("on", self, "on")
	EventMan.connect("reset", self, "reset")

func reset():
	if (int(properties["starts_on"])>0) if "starts_on" in properties else false:
		out_state = true
		$"/root/EventMan".circuit_on(out_circuit)

func on(name: String):
	if name == in_circuit:
		out_state = !out_state
		$"/root/EventMan".call("circuit_on" if out_state else "circuit_off", out_circuit)
