extends ScrollContainer

onready var frame_parent: HBoxContainer = $HBoxContainer;
onready var t: Tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	push_frame("root")
	pass # Replace with function body.


func push_frame(frame_id: String):
	var frame = load("res://scenes/menu2/levels/"+frame_id+".tscn");
	push_scene(frame)

func push_scene(pframe: PackedScene):
	var frame = pframe.instance()
	frame.frame_index = frame_parent.get_child_count()
	frame.visible = false
	frame_parent.add_child(frame)
	t.interpolate_property(frame, "modulate", Color.transparent, Color.white, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT);
	t.start()
	frame.visible = true
	set_focus()
	frame.connect("push", self, "push")
	frame.connect("pop", self, "pop")

func set_focus():
	var frame = frame_parent.get_child(frame_parent.get_child_count() - 1);
	for child in frame.get_node("VBoxContainer").get_children():
		if child is Button:
			child.grab_focus()
			break;

func push(from: int, to: String):
	pop(from)
	while popping:
		yield(get_tree(), "idle_frame")
	push_frame(to)

var popping = false

func pop(from: int):
	popping = true
	while frame_parent.get_child(frame_parent.get_child_count() - 1).frame_index != from:
		var frame = frame_parent.get_child(frame_parent.get_child_count() - 1)
		t.interpolate_property(frame, "modulate", Color.white, Color.transparent, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN);
		t.start()
		while yield(t, "tween_completed")[0] != frame:
			yield(get_tree(), "idle_frame")
		frame.die(frame)
		yield(get_tree(), "idle_frame")
	set_focus()
	popping = false
	
