extends VBoxContainer

var spool = false
var line_amt = 4

const log_lines = [
	"Scanning for haunted files...",
	"Running spook_prober...",
	"Changing system font...",
	"Playing Gex in the background...",
	"Distrohopping..."
]

func start_spooling():
	spool = true
	for child in get_children():
		child.queue_free()

func stop_spooling():
	spool = false
	for child in get_children():
		child.queue_free()

func _physics_process(delta):
	if not spool:
		return
	if get_child_count() > line_amt:
		get_child(0).queue_free()
	var label = Label.new()
	label.autowrap = true
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.add_font_override('font', preload('./monitor_font_smaller.tres'))
	label.text = log_lines[floor(rand_range(0, len(log_lines)))]
	add_child(label)
