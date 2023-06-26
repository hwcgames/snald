extends Label

export var speed: float
export var id: String

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0.0
	if speed > 0:
		visible_characters = 0
	pass # Replace with function body.

var timer: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer += delta
	if timer > speed and speed > 0 and visible_characters < len(text):
		timer = 0
		visible_characters += 1
	pass
