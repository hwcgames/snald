extends Node
class_name RandomBgSounds

export var chance = 0.05

func _ready():
	EventMan.connect("power_tick", self, "tick")

func tick():
	if rand_range(0, 1) > chance:
		return
	var upper_bound = 0
	for child in get_children():
		if not child is SoundChoice:
			continue
		upper_bound += child.weight
	var choice = rand_range(0, upper_bound)
	for child in get_children():
		if not child is SoundChoice:
			continue
		choice -= child.weight
		if choice <= 0:
			child.go()
			break
	
