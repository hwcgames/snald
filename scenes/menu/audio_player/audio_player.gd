extends AudioStreamPlayer

onready var p_btn = $"%PlayPauseButton"
onready var scrubber = $"%Scrubber"
onready var timer = $"%Timer"
var position = 0.0
var update_slider = true

func _ready():
	p_btn.connect("toggled", self, "play_pause")
	connect("finished", self, "finished")
	scrubber.connect("drag_ended", self, "scrub")
	scrubber.connect("drag_started", self, "scrub_start")
	yield(get_tree(), "idle_frame")
	if stream:
		scrubber.tick_count = int(floor(stream.get_length() / 10))

func _process(_delta):
	if not self.stream:
		return
	position = self.get_playback_position()
	var minutes = str(floor(position / 60)).pad_zeros(2)
	var seconds = str(int(floor(position)) % 60).pad_zeros(2)
	timer.text = minutes + ':' + seconds
	if update_slider:
		scrubber.value = scrubber.max_value * position / self.stream.get_length()

func scrub_start():
	update_slider = false

func scrub(changed: bool):
	update_slider = true
	if not changed:
		return
	position = self.stream.get_length() * (scrubber.value / scrubber.max_value)
	seek(position)

func finished():
	play_pause(false)
	p_btn.pressed = false
	position = 0

func play_pause(playing: bool):
	if playing and !self.playing:
		play(position)
	if (not playing) and self.playing:
		self.stop()
		position = self.get_playback_position()
	p_btn.text = '||' if playing else '>'
