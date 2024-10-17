extends Node2D

@onready var levels_node = Node2D.new()

signal stage_changed()
signal area_changed(new_area: Vector2i)

var visible_level: Node2D:
	set(new_value):
		emit_signal("area_changed", new_value.global_position)
		visible_level = new_value

var direction_startpos = Vector2(0, 0)
var level_direction = Vector2(1, 0)

var current_level: int = 1:
	set(new_value):
		if new_value == 5:
			level_direction = Vector2(0, 1)
			direction_startpos = Vector2(1536, 1536)
			print("South wrap should be here")
			var next_level = load("res://world_campaign/levels/level" + str((new_value-1)%3+1) + ".tscn").instantiate()
			print(next_level)
			print("ADDED LEVEL")
			levels_node.add_child(next_level)
			next_level.global_position = Vector2(1536, 1536)
			print("NEW POS" + str(next_level.global_position))
			var kit_node = get_tree().root.get_node("World/Kit")
			kit_node.moving = false
			kit_node.move_tween.stop()
			kit_node.position = Vector2(0, 0)
			kit_node.global_position = Vector2(1536, 1536) + Vector2(96, 56)
			var cam_node = get_tree().root.get_node("World/Camera2D")
			cam_node.global_position = Vector2(1536, 1536)
			current_level = new_value
		elif new_value == 9:
			level_direction = Vector2(-1, 0)
			print("East wrap should be here")
			# TODO: Warp to east
		elif new_value == 13:
			level_direction = Vector2(0, -1)
			print("North wrap should be here")
			# TODO: Warp to north
		elif new_value == 17:
			print("Boss wave should start here")
			# TODO: Start boss wave
		else:
			var next_level = load("res://world_campaign/levels/level" + str((new_value-1)%3+1) + ".tscn").instantiate()
			levels_node.add_child(next_level)
			next_level.global_position = direction_startpos + level_direction * (384 * current_level)
			current_level = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels_node.y_sort_enabled = true
	add_child(levels_node)
	connect("stage_changed", _next_level)
	var lv1 = preload("res://world_campaign/levels/level1.tscn").instantiate()
	visible_level = lv1
	levels_node.add_child(lv1)

func _next_level():
	Global.heat += 0.3
	var arrow = load("res://world_campaign/arrow.tscn").instantiate()
	arrow.global_position = direction_startpos + level_direction * (384 * current_level)
	# Center the arrow
	if level_direction == Vector2(1, 0):
		arrow.global_position += Vector2(0, 7*16)
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
