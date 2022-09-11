extends QodotEntity
class_name DecorTrain

var path_cursor = 0
var path_segments = []
var track_name = "default"
var model_name = "train1"
var speed = 1.0
var size = 1.0

func _ready():
	yield(get_parent(), "build_complete")
	track_name = str(properties["track_name"]) if "track_name" in properties else track_name
	model_name = str(properties["model_name"]) if "model_name" in properties else model_name
	speed = float(properties["speed"]) if "speed" in properties else 1.0
	size = float(properties["scale"]) if "scale" in properties else 1.0
	# Load the train scene
	var sc = load("res://eggs/trains/train_models/"+model_name+"/"+model_name+".glb")
	var train: Spatial = sc.instance()
	train.scale = Vector3(1,1,1) * size
	add_child(train)
	# Get all of the train landmarks
	path_segments = MapQuery.query({"classname": "DecorTrainPath", "track_name": track_name})
	path_segments.sort_custom(self, "cmp_segment")

func cmp_segment(a, b):
	return int(a.properties["index"]) < int(b.properties["index"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(path_segments) == 0:
		return
	var pos: Vector3 = transform.origin
	var goal: Vector3 = path_segments[path_cursor].transform.origin
	var dir = (goal - pos).normalized()
	var distance = (goal - pos).length()
	var amount = min(distance, delta * speed)
	transform.origin += dir * amount
	if (goal - pos).length() < 0.1:
		path_cursor += 1
		if path_cursor >= len(path_segments):
			path_cursor = 0
	rotation.y = lerp_angle(rotation.y, (-Vector2(dir.x, dir.z).angle()) - 80, 10 * delta)
