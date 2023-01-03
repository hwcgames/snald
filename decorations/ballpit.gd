extends Spatial

export var play_now = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if play_now:
		play()
		play_now = false;
	pass

func play():
	var main_player: AnimationPlayer = $AnimationPlayer
	for animation_name in main_player.get_animation_list():
		var sub_player: AnimationPlayer = AnimationPlayer.new();
		var animation: Animation = main_player.get_animation(animation_name)
		animation.loop = false
		sub_player.add_animation(animation_name, animation)
		add_child(sub_player)
		sub_player.play(animation_name)
		if animation_name == "ArmatureAction":
			sub_player.advance(10.0)
		sub_player.connect("animation_finished", sub_player, "queue_free")
