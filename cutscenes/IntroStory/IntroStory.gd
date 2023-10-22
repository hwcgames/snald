extends Node

func _ready():
	var env: WorldEnvironment = $"/root/gameplay/%WorldEnvironment"
	env.environment = preload("res://cutscenes/IntroStory/intro_story_environment.tres")
	EventMan.pause = true
	var lucas: Lucas
	for character in get_tree().get_nodes_in_group("animatronics"):
		if character is Lucas:
			character.difficulty = 0
			lucas = character
			break
	var player: FreeRoamPlayer = get_tree().get_nodes_in_group("player")[0]
	CutsceneMan.player_cutscene_mode = true
	yield(get_tree(), "idle_frame")
	player_look_at_lucas(player, lucas)
	while abs(player.rotation_degrees.y - CutsceneMan.player_cutscene_goal) > 0.1:
		yield(get_tree(), "idle_frame")
	CutsceneMan.player_cutscene_mode = false
	pass # Replace with function body.

func player_look_at_lucas(player: FreeRoamPlayer, lucas: Lucas):
#	var player_pos = player.global_transform.origin
#	var lucas_pos = lucas.global_transform.origin
#	var player_pos2 = Vector2(player_pos.x, player_pos.z)
#	var lucas_pos2 = Vector2(lucas_pos.x, lucas_pos.z)
#	var angle = player_pos2.angle_to(lucas_pos2)
#	CutsceneMan.player_cutscene_goal = angle * (180.0 / PI)
	pass
