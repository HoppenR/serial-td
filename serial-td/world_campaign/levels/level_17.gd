extends Node2D

const BASE_PATH_SCRIPT = preload("res://path/basepath.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels: Node2D = get_tree().root.get_node("World").levels_node
	for i in range(4):
		_create_path(levels, i)

func _create_path(levels: Node2D, number: int) -> void:
	var path = Path2D.new()
	var curve = Curve2D.new()
	path.set_script(BASE_PATH_SCRIPT)
	path.position = Vector2(225, 144)
	var path_levels: Array[Node2D] = [
		levels.get_node("Level" + str(number * 4 + 4)),
		levels.get_node("Level" + str(number * 4 + 3)),
		levels.get_node("Level" + str(number * 4 + 2)),
		levels.get_node("Level" + str(number * 4 + 1)),
	]
	for cur_level in path_levels:
		var level_offset = cur_level.global_position - global_position
		var cur_path = cur_level.get_node("EnemyPath")
		var cur_curve = cur_path.curve
		for point_idx in range(cur_curve.get_point_count()):
			var point = cur_curve.get_point_position(point_idx) + level_offset
			curve.add_point(point, Vector2(), Vector2())
	path.curve = curve
	add_child(path)
