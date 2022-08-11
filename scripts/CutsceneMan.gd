extends Node

var cutscene_blocker = preload("res://scenes/cutscene/blocker.tscn")
var cutscene_text = preload("res://scenes/cutscene/text.tscn")
var player_cutscene_mode = false
var player_cutscene_goal: float = 0.0

signal advance_cutscene

func _ready():
	pass # Replace with function body.

func remove(node: Node):
	for i in node.get_children():
		remove(i)
	node.remove_and_skip()

func stop_cutscene():
	for i in get_children():
		remove(i)
	player_cutscene_mode = false

func start_cutscene(cutscene: PackedScene):
	stop_cutscene()
	add_child(cutscene_blocker.instance())
	add_child(cutscene.instance())

func advance_cutscene():
	emit_signal("advance_cutscene")

func cutscene_is_running():
	return len(get_children()) > 0

func put_text(text: String, position=Vector2(0.5, 0.5), speed=0.01, centered=true, id="default_text_id", font=preload("res://font/normal.tres")):
	remove_text(id)
	var text_s = cutscene_text.instance()
	text_s.id = id
	text_s.text = text
	text_s.speed = speed
	text_s.anchor_left = position.x
	text_s.anchor_right = position.x
	text_s.anchor_top = position.y
	text_s.anchor_bottom = position.y
	text_s.add_font_override("Font", font)
	text_s.grow_horizontal = -1 if centered else 1
	$Blocker.add_child(text_s)

func remove_text(id="default_text_id", time=0.5, transition=Tween.TRANS_LINEAR, easing=Tween.EASE_IN_OUT):
	var tween = Tween.new();
	add_child(tween)
	var any_found = []
	for i in $Blocker.get_children():
		if i is Label and i.id == id:
			any_found.push_back(i)
			tween.interpolate_property(i, "modulate", i.modulate, Color(1, 1, 1, 0), time, transition, easing)
	if len(any_found) > 0:
		tween.start()
	yield(tween, "tween_all_completed")
	tween.remove_and_skip()
	for i in any_found:
		remove(i)

func get_tween():
	var tween = Tween.new()
	add_child(tween)
	tween.connect("tween_all_completed", tween, "remove_and_skip")
	return tween

func wait(time=1.0):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.start()
	yield(timer, "timeout")
	timer.remove_and_skip()
