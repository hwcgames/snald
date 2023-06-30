extends AnimatronicBase
class_name Willow


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monitor_world = $display_on_monitor
var visible_states = [4]
var lookaway = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $wolo/AnimationPlayer
	add_to_group("display_on_monitor")
	connect("change_state", self, "new_state")
	assume_state(0)
	EventMan.connect("on", self, "on")
	EventMan.connect("off", self, "off")
	pass
#connect to the circuits which track if  the player is looking at the monitor

func new_state(id: int):
	if id in visible_states:
		show()
		$BreathingPlayer.play()
	else:
		$BreathingPlayer.stop()
		hide()

func looking_at_monitor():
	return $"/root/EventMan".circuit("looking_at_monitor") and not $"/root/EventMan".circuit("player_camera_pad")

func state_machine():
	if looking_at_monitor() and not state == 4:
		return state
	elif state == 4:
		$"/root/EventMan".jumpscare("willow", "willow")
		return 0
	else:
		return state + 1

func on(circuit):
	if circuit == "player_camera_pad":
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = .2
		timer.start()
		yield(timer,"timeout")
		timer.remove_and_skip()
		if state == 4:
			$"/root/EventMan".jumpscare("willow", "willow")
			assume_state(0)
		else:
			lookaway_attack()
	if circuit == "computer_restart":
			assume_state(0)

func off(circuit):
	if circuit == "looking_at_monitor":
		if state == 4:
			$"/root/EventMan".jumpscare("willow", "willow")
			assume_state(0)
		else:
			lookaway_attack()
			
func difficulty_offset():
	if lookaway:
		return -ceil(difficulty * .75)
	return 0
	
func lookaway_attack():
	lookaway = true
	animatronic_tick()
	lookaway = false
	
	

