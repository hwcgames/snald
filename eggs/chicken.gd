extends Node

func new_text(new_text):
	match new_text:
		"music make me lose control":
			get_tree().change_scene("res://eggs/sound_test.tscn")
		"fastest mario":
			$"/root/SpeedrunTimer".start()
