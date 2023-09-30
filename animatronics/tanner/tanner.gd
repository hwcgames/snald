extends Spatial
class_name Tanner

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
var killscreen: bool = false
var boomboxing: bool = false
var length: int = 0
var note_wait: float = 0.5

var song_choices: Array = CVars.get_table(CVars.get_table("tanner_tables").get("deterministic_songs")).songs
export var note_samples: Array = []
export var note_colors: Array = []
export var punishment_songs: Array = CVars.get_table(CVars.get_table("tanner_tables").get("punishment_songs")).songs

signal song_finished

func _physics_process(_delta):
	if boomboxing and not EventMan.circuit("noisy"):
		EventMan.circuit_on("noisy")

func reset():
	timer.stop()
	punisher.stop()
	get_parent().call_deferred("spawn_animatronic", "tanner")
	remove_visitor(self)

func remove_visitor(n: Node):
	for c in n.get_children():
		remove_visitor(c)
	n.queue_free()

func _ready():
	length = self.difficulty
	assume_state(0)
	EventMan.connect("on", self, "on")
	EventMan.connect("reset", self, "reset")
	timer.connect("timeout", self, "finish_boombox")
	while true:
		# TBD how timer should work
		var start_wait_time = get_node("../CompletionTimer").wait_time / (CVars.get_int("tanner_challenge_amt") + 1.9)
		if difficulty >= 20:
			start_wait_time = 2 if EventMan.has_reset else 20
		var start_timer = get_tree().create_timer(start_wait_time)
		song_is_correct = false
		yield(start_timer, "timeout")
		# Play explosion noise
		EventMan.circuit_on("tanner_broken_ceiling")
		ap.play("enter")
		yield(ap, "animation_finished")
		if difficulty >= 20:
			note_wait = 0.1
			length = 100
			killscreen = true
			CVars.set_float("punishment_song_length", 3600.0)
		gen_song()
		yield(self, "song_finished")
		CutsceneMan.remove_text("tanner_song_text")
		CutsceneMan.stop_cutscene()
		if song_is_correct:
			ap.play("success")
			yield(ap, "animation_finished")
			EventMan.circuit_on("give_battery")
			EventMan.circuit_off("give_battery")
			length += CVars.get_float("song_length_increase_rate")
		else:
			PersistMan.set_flag('tanner_song_failed', true)
			ap.play("failure")
			yield(ap, "animation_finished")
			if not killscreen:
				timer.wait_time = CVars.get_float("punishment_song_length")
				timer.start()
			EventMan.circuit_on("noisy")
			tween.interpolate_property($"/root/gameplay/AudioStreamPlayer", "volume_db", 0, -10, 1)
			tween.interpolate_property(punisher, "volume_db", -10, 0, 1)
			tween.start()
			var song = load(punishment_songs[rand_range(0, len(punishment_songs))])
			if killscreen:
				song = load("res://music/night5.ogg")
				for i in range(CVars.get_int("tanner_n20_battery_count")):
					EventMan.circuit_on("give_battery")
					EventMan.circuit_off("give_battery")
					yield(get_tree(), "idle_frame")
					yield(get_tree(), "idle_frame")
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
	if killscreen:
		goal_song = PoolIntArray([])
		player_song = goal_song
		song_is_correct = false
		$NoteTimer.queue_free()
		emit_signal("song_finished")
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
	var sound = load('res://animatronics/tanner/'+str(note-1)+'.ogg')
	$AudioStreamPlayer3D.stop()
	$AudioStreamPlayer3D.stream = sound
	$AudioStreamPlayer3D.play()
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
	var string = ""
	CutsceneMan.add_child(CutsceneMan.cutscene_blocker.instance())
	for note in song:
		play_note(note)
		$NoteTimer.wait_time = note_wait
		$NoteTimer.start()
		string += str(note) + ", "
		CutsceneMan.remove_text("tanner_song_text", 0)
		if CVars.get_bool("show_song_notes"):
			CutsceneMan.put_text(string, Vector2(0.5, 0.6), 0, true, "tanner_song_text")
		yield($NoteTimer, "timeout")
	if difficulty >= 20:
		song_is_correct = false
		emit_signal("song_finished")

func gen_song():
	var roll_for_deterministic_song = rand_range(0,20) < CVars.get_float("deterministic_song_chance")
	if roll_for_deterministic_song:
		choose_song()
		return
	player_song = PoolIntArray([])
	goal_song = PoolIntArray([])
	for _n in range(round(length)/2):
		goal_song.append(round(rand_range(1,8)))
	play_song()

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
