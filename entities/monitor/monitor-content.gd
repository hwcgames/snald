extends Control

func _ready():
	EventMan.connect("reset", self, "reset")
	EventMan.connect("on", self, "on")
	reset()

func reset():
	$"%TabContainer".current_tab = 0
	$"%LogContainer".stop_spooling()
	$"%Login".mappings = []

func on(circuit):
	if circuit == "computer_restart":
		reboot()

func reboot():
	EventMan.circuit_on("computer_is_down")
	$"%TabContainer".current_tab = 1
	$"%LogContainer".start_spooling()
	yield(get_tree().create_timer(CVars.get_float("reboot_time")), "timeout")
	$"%LogContainer".stop_spooling()
	$"%TabContainer".current_tab = 2
	$"%Login".login()
	yield($"%Login", "success")
	$"%TabContainer".current_tab = 0
	EventMan.circuit_off("computer_is_down")
