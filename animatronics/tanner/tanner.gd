extends Spatial

const note_prefix: String = "piano_"
const piano_index: int = 6
const piano_key_color: Color = Color("#e7e7e7")

onready var ap: AnimationPlayer = $tanner/AnimationPlayer
onready var timer: Timer = $Timer
onready var mesh: Mesh = $tanner/Armature/Skeleton/Cube.mesh
onready var tween: Tween = $Tween
onready var punisher: AudioStreamPlayer = $PunishmentSongPlayer

var id = "tanner"
var difficulty = 10

var goal_song: PoolIntArray = PoolIntArray([])
var player_song: PoolIntArray = PoolIntArray([])
var song_is_correct: bool = false
var boomboxing: bool = false

var song_choices: Array = [
	PoolIntArray([1,2,3,4,5,6,7,8])
]
export var note_samples: Array = []
export var note_colors: Array = []
export var punishment_songs: PoolStringArray = []

signal song_finished

func _ready():
	assume_state(0)
	EventMan.connect("on", self, "on")
	timer.connect("timeout", self, "finish_boombox")
	while true:
		# TBD how timer should work
		timer.wait_time = 5
		timer.start()
		song_is_correct = false
		yield(timer, "timeout")
		ap.play("enter")
		yield(ap, "animation_finished")
		choose_song()
		yield(self, "song_finished")
		if song_is_correct:
			ap.play("success")
			yield(ap, "animation_finished")
			EventMan.circuit_on("give_battery")
			EventMan.circuit_off("give_battery")
		else:
			ap.play("failure")
			yield(ap, "animation_finished")
			timer.wait_time = 20
			timer.start()
			EventMan.circuit_on("noisy")
			tween.interpolate_property($"/root/gameplay/AudioStreamPlayer", "volume_db", 0, -10, 1)
			tween.interpolate_property(punisher, "volume_db", -10, 0, 1)
			tween.start()
			var song = load(punishment_songs[rand_range(0, len(punishment_songs))])
			punisher.stream = song
			punisher.play()
			boomboxing = true
			while boomboxing:
				ap.play("boombox_swing")
				yield(ap, "animation_finished")
			ap.play("boombox_leave")
			yield(ap, "animation_finished")
			tween.interpolate_property($"/root/gameplay/AudioStreamPlayer", "volume_db", -10, 0, 1)
			EventMan.circuit_off("noisy")
		pass

func choose_song():
	# TBD how this will work
	var index = rand_range(0,len(song_choices))
	var song = song_choices[index]
	goal_song = song as PoolIntArray
	player_song = PoolIntArray([])
	play_song()

func on(circuit: String):
	if not circuit.substr(0, len(note_prefix)) == note_prefix or circuit.ends_with("_not"):
		return
	var note = int(circuit.substr(len(note_prefix)))
	play_note(note)
	if len(goal_song) > 0:
		player_song.push_back(note)
		check_song()

func check_song():
	if len(goal_song) == 0:
		player_song = PoolIntArray([])
		return
	for i in range(len(player_song)):
		if player_song[i] != goal_song[i]:
			goal_song = PoolIntArray([])
			player_song = goal_song
			song_is_correct = false
			emit_signal("song_finished")
			return
	if len(player_song) == len(goal_song):
		goal_song = PoolIntArray([])
		player_song = goal_song
		song_is_correct = true
		emit_signal("song_finished")

func play_note(note: int):
	print("Note " + str(note))
	var slot_index = piano_index + note - 1
	var mat: SpatialMaterial = mesh.surface_get_material(slot_index)
	tween.interpolate_property(mat, "albedo_color", note_colors[note - 1], piano_key_color, 0.5)
	tween.start()
	pass

func finish_boombox():
	boomboxing = false
	tween.interpolate_property(punisher, "volume_db", 0, -50, 3.0)
	tween.start()
	yield(tween, "tween_completed")
	punisher.stop()

func play_song():
	var song = goal_song
	for note in song:
		play_note(note)
		$NoteTimer.wait_time = 0.5
		$NoteTimer.start()
		yield($NoteTimer, "timeout")

# Copied functionality from AnimatronicBase
func assume_state(new_state: int):
	var target = get_node_for_state(new_state)
	global_transform.origin = target.global_transform.origin
	rotation_degrees.y = target.get_angle()
	ap.play("tpose")
	ap.play(target.get_animation())
func get_node_for_state(state: int):
	var all = get_nodes_for_state(state)
	var index = floor(rand_range(0, len(all)))
	return all[index]
func get_nodes_for_state(state: int):
	var all = get_nodes_for_me()
	var relevant = []
	for i in all:
		if i.get_state() == state:
			relevant.push_front(i)
	return relevant
func get_nodes_for_me():
	var all = get_tree().get_nodes_in_group("AnimatronicPosition")
	var relevant = []
	for i in all:
		if i.get_animatronic() == id:
			relevant.push_front(i)
	return relevant
