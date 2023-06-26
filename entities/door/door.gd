extends QodotEntity

var height = -INF
var starting_position = Vector3.ZERO
var open = false
var since_updated = 0.0
var open_time = 1.0
var easing = -2
var circuit = "default"
var depleted = false
var power_consumption = 1
var affects_temperature = 0
var closing = preload("res://music/motor.ogg")
var closed = preload("res://music/door-sound.ogg")
var opened = preload("res://music/door-sound-opened.ogg")
onready var player = AudioStreamPlayer.new()

func _ready():
	yield(get_parent(), "build_complete")
	starting_position = global_transform.origin
	var highest = -INF
	var lowest = INF
	for i in get_children():
		if i is CollisionShape and i.shape is ConvexPolygonShape:
			for p in i.shape.points:
				highest = max(p.y, highest)
				lowest = min(p.y, lowest)
	height = highest - lowest
	open_time = properties["open_time"] if "open_time" in properties else open_time
	easing = properties["easing"] if "easing" in properties else easing
	circuit = properties["circuit"] if "circuit" in properties else circuit
	power_consumption = properties["power_consumption"] if "power_consumption" in properties else 0
	affects_temperature = properties["affects_temperature"] if "affects_temperature" in properties else 0
	var _err = $"/root/EventMan".connect("on", self, "on")
	_err = $"/root/EventMan".connect("off", self, "off")
	_err = $"/root/EventMan".connect("power_tick", self, "power_tick")
	if affects_temperature == 1:
		_err = $"/root/EventMan".connect("temperature_tick", self, "temperature_tick")
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if height != -INF && since_updated < open_time:
		var power = ease(min(since_updated / open_time, 1), easing)
		var from = Vector3.UP * height * (0 if open else 1)
		var offset = Vector3.UP * height * (1 if open else -1) * power
		global_transform.origin = starting_position + from + offset
		since_updated += delta
		if since_updated >= open_time && (properties["sound"] if "sound" in properties else "false") == "true":
			player.stop()
			player.stream = opened if open else closed
			player.play()
	
func on(name: String):
	if name == circuit and not depleted:
		open = true
		since_updated = 0
		if (properties["sound"] if "sound" in properties else "false") == "true":
			player.stop()
			player.stream = closing
			player.play()
func off(name: String):
	if name == circuit and not depleted:
		open = false
		since_updated = 0
		if (properties["sound"] if "sound" in properties else "false") == "true":
			player.stop()
			player.stream = closing
			player.play()

func power_tick():
	if $"/root/EventMan".power <= 0 and not depleted:
		open = true
		since_updated = 0
		depleted = true
	if not open:
		$"/root/EventMan".power -= power_consumption

func temperature_tick():
	if open == false:
		$"/root/EventMan".temperature += 2
	else:
		$'/root/EventMan'.temperature -= 1
