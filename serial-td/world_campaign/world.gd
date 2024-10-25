extends Node2D

@onready var levels_node = Node2D.new()
@onready var kit_node = get_tree().root.get_node("World/Kit")
@onready var cam_node = get_tree().root.get_node("World/Camera2D")

signal stage_changed()
signal area_changed(new_area: Vector2i)

var visible_level: Node2D:
	set(new_value):
		if not is_bosslevel:
			emit_signal("area_changed", new_value.global_position)
		visible_level = new_value

var direction_startpos = Vector2(0, 0)
var level_direction = Vector2(1, 0)
var is_bosslevel: bool = false

var current_level: int = 1:
	set(new_value):
		if new_value == 5: # 5
			kit_node.get_node("Sprite2D").texture = load("res://assets/kit/cat_bl.webp")
			kit_node.teleport(Vector2(384*4, 256*4))
			cam_node.global_position = Vector2(384*4, 256*4)
			level_direction = Vector2(0, -1)
			direction_startpos = Vector2(384*4, 256*(4+4))
		elif new_value == 9: # 9
			kit_node.get_node("Sprite2D").texture = load("res://assets/kit/cat_yl.webp")
			kit_node.teleport(Vector2(384*8, 0))
			cam_node.global_position = Vector2(384*8, 0)
			level_direction = Vector2(-1, 0)
			direction_startpos = Vector2(384*(8+8), 0)
		elif new_value == 13: # 13
			kit_node.get_node("Sprite2D").texture = load("res://assets/kit/cat_pi.webp")
			kit_node.teleport(Vector2(384*4, 256*-4))
			cam_node.global_position = Vector2(384*4, 256*-4)
			level_direction = Vector2(0, 1)
			direction_startpos = Vector2(384*4, 256*-(4+12))
		elif new_value == 17: # 17
			cam_node.zoom = Vector2(0.4, 0.4)
			cam_node.global_position = Vector2i(0, 256*-4)
			is_bosslevel = true
			Global.heat += 2.0
		var next_level = load("res://world_campaign/levels/level" + str(new_value) + ".tscn").instantiate()
		next_level.global_position = direction_startpos + level_direction * Vector2(384 * current_level, 256 * current_level)
		levels_node.add_child(next_level)
		current_level = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels_node.y_sort_enabled = true
	add_child(levels_node)
	connect("stage_changed", _next_level)
	var lv1 = preload("res://world_campaign/levels/level1.tscn").instantiate()
	visible_level = lv1
	kit_node.get_node("Sprite2D").texture = load("res://assets/kit/cat_gr.webp")
	levels_node.add_child(lv1)

func _next_level():
	if current_level == 18:
		print("You won!")
		get_tree().paused = true
	Global.heat += 0.05
	Global.gold += 1000
	var arrow = load("res://world_campaign/arrow.tscn").instantiate()
	arrow.global_position = direction_startpos + level_direction * Vector2(384 * (current_level-1), 256 * (current_level-1))
	# Center the arrow
	if level_direction == Vector2(1, 0):
		arrow.global_position += Vector2(384, 7*16)
	elif level_direction == Vector2(0, -1):
		arrow.global_position += Vector2(6*32, 16)
		arrow.rotation = 3*PI/2
	elif level_direction == Vector2(-1, 0):
		arrow.global_position += Vector2(16, 8*16)
		arrow.rotation = PI
	elif level_direction == Vector2(0, 1):
		arrow.global_position += Vector2(6*32, 15*16)
		arrow.rotation = PI/2
	add_child(arrow)
	arrow.get_node("Area2D").connect("body_entered", func(body):
		if body.name == "Kit":
			current_level += 1
			arrow.queue_free()
	)

func get_cell_tile_data(coords: Vector2) -> TileData:
	# First check for the level that should be visible previously
	var tilemap_layer: TileMapLayer = visible_level.get_node("PlayerTraversal")
	var local_coords: Vector2i = tilemap_layer.local_to_map(coords - tilemap_layer.global_position)
	var tile_data: TileData = tilemap_layer.get_cell_tile_data(local_coords)
	if tile_data:
		return tile_data

	# If not found, check all children, notify of any visible_level change (using its setter)
	for level in levels_node.get_children():
		tilemap_layer = level.get_node("PlayerTraversal")
		local_coords = tilemap_layer.local_to_map(coords - tilemap_layer.global_position)
		tile_data = tilemap_layer.get_cell_tile_data(local_coords)
		if tile_data:
			visible_level = level
			return tile_data
	print("ERROR: No areas has this point" + str(coords))
	return TileData.new()
