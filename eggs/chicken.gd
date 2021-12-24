extends Node

func new_text(new_text):
	match new_text:
		"here comes the boy":
			get_tree().change_scene("res://eggs/sound_test.tscn")
		"fastest mario":
			$"/root/SpeedrunTimer".start()
