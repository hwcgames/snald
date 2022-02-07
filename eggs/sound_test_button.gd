extends Button

export var song: AudioStream
export var player: NodePath

func _pressed():
	get_node(player).stream = song
