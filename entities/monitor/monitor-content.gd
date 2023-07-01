extends Control

func _ready():
	EventMan.connect("reset", self, "reset")
	EventMan.connect("on", self, "on")
	add_child(timer)
	reset()

func reset():
	$"%TabContainer".current_tab = 0
	$"%LogContainer".stop_spooling()
	$"%Login".mappings = []
	timer.stop()
	timer.queue_free()
	timer = Timer.new()
	add_child(timer)

func on(circuit):
	if circuit == "computer_restart":
		reboot()

var timer = Timer.new()

func reboot():
	EventMan.circuit_on("computer_is_down")
	$"%TabContainer".current_tab = 1
	$"%LogContainer".start_spooling()
	timer.wait_time = CVars.get_float("reboot_time")
	timer.start()
	yield(timer, "timeout")
	$"%LogContainer".stop_spooling()
	$"%TabContainer".current_tab = 2
	$"%Login".login()
	yield($"%Login", "success")
	$"%TabContainer".current_tab = 0
	EventMan.circuit_off("computer_is_down")
