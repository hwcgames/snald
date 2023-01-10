extends Node

func new_text(new_text):
	match new_text:
		"music make me lose control":
			var _err = get_tree().change_scene("res://eggs/sound_test.tscn")
		"fastest mario":
			$"/root/SpeedrunTimer".start()
		"shibboleet":
			PersistMan.set_flag("developer")
			PersistMan.save_game()
			get_tree().reload_current_scene()
