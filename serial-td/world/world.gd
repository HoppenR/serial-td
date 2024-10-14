extends Node2D

@onready var levels_node = Node2D.new()

signal stage_changed()
signal area_changed(new_area: Vector2i)

var visible_level: Node2D:
	set(new_value):
		emit_signal("area_changed", new_value.global_position)
		visible_level = new_value

var current_level: int = 1:
	set(new_value):
		# TODO(Christoffer): Crashes at level 4
		var next_level = load("res://level" + str(new_value) + ".tscn").instantiate()
		levels_node.add_child(next_level)
		# NOTE: Only places levels to the right (east)
		next_level.global_position = Vector2i(192 * new_value + 192 * (current_level - 1), 0)
		current_level = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels_node.y_sort_enabled = true
	add_child(levels_node)
	connect("stage_changed", _next_level)
	var lv1 = preload("res://level1.tscn").instantiate()
	visible_level = lv1
	levels_node.add_child(lv1)

func _next_level():
	Global.heat += 0.3
	current_level += 1

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
