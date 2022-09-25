extends PanelContainer

signal pop(frame_index);
signal push(frame_index, frame_id);

var frame_index = 0;

func _ready():
	explore_children(self)
	pass # Replace with function body.

func explore_children(node: Node):
	if node.has_signal("pop") and node is Button:
		node.connect("pop", self, "pop")
	if node.has_signal("push") and node is Button:
		node.connect("push", self, "push")
	for child in node.get_children():
		explore_children(child)

func pop():
	emit_signal("pop", frame_index - 1)

func push(frame: String):
	emit_signal("push", frame_index, frame)

func die(node = self):
	for child in node.get_children():
		die(child)
	self.queue_free()
