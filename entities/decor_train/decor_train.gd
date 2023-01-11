extends QodotEntity
class_name DecorTrain

var path_cursor = 0
var path_segments = []
var track_name = "default"
var model_name = "train1"
var speed = 1.0
var size = 1.0

var train: Spatial
onready var follower = PathFollow.new()

func _ready():
	yield(get_parent(), "build_complete")
	track_name = str(properties["track_name"]) if "track_name" in properties else track_name
	model_name = str(properties["model_name"]) if "model_name" in properties else model_name
	speed = float(properties["speed"]) if "speed" in properties else 1.0
	size = float(properties["scale"]) if "scale" in properties else 1.0
	# Load the train scene
	var sc = load("res://eggs/trains/train_models/"+model_name+"/"+model_name+".glb")
	train = sc.instance()
	train.scale = Vector3(1,1,1) * size
	# Get all of the train landmarks
	path_segments = MapQuery.query({"classname": "DecorTrainPath", "track_name": track_name})
	path_segments.sort_custom(self, "cmp_segment")
	var path = Path.new()
	for segment_index in range(len(path_segments)) + [0]:
		var segment = path_segments[segment_index];
		var next_index = segment_index + 1
		var prev_index = segment_index - 1
		if next_index >= len(path_segments):
			next_index -= len(path_segments)
		if prev_index < 0:
			prev_index += len(path_segments)
		var next: Vector3 = path_segments[next_index].global_transform.origin
		var prev: Vector3 = path_segments[prev_index].global_transform.origin
		var curr: Vector3 = segment.global_transform.origin
		var to_prev: Vector3 = lerp(curr, prev, 0.25) - curr
		var to_next: Vector3 = lerp(curr, next, 0.25) - curr
		var handle = ((to_next - to_prev) / 2).normalized()
		path.curve.add_point(curr, -handle * to_prev.length() * 1.3, handle * to_next.length() * 1.3)
	add_child(path)
	path.global_transform = Transform.IDENTITY
	follower.rotation_mode = follower.ROTATION_Y
	follower.loop = true
	path.add_child(follower)
	follower.add_child(train)

func cmp_segment(a, b):
	return float(a.properties["index"]) < float(b.properties["index"])

var last_pos = Vector3(0, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follower.offset += delta * speed
	if train:
		train.look_at(last_pos, Vector3.UP)
		last_pos = train.global_transform.origin
