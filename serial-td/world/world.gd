extends Node2D

@onready var levels_node = Node2D.new()

signal stage_changed()

var current_level: int = 1:
	set(new_value):
		# TODO(Christoffer): Crashes at level 4
		var next_level = load("res://level" + str(new_value) + ".tscn").instantiate()
		levels_node.add_child(next_level)
		# TODO: Move next level at an offset
		next_level.global_position = Vector2i(192 * new_value + 160 * (current_level - 1), 0)
		# next_level.y_sort_origin = 0
		current_level = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels_node.y_sort_enabled = true
	add_child(levels_node)
	connect("stage_changed", _next_level)
	var lv1 = preload("res://level1.tscn").instantiate()
	levels_node.add_child(lv1)
	# Load level 3
	#current_level = 3

func _next_level():
	Global.heat += 0.2
	current_level += 1

func get_cell_tile_data(coords: Vector2) -> TileData:
	for level in levels_node.get_children():
		var tilemap_layer: TileMapLayer = level.get_node("PlayerTraversal")
		var local_coords = tilemap_layer.local_to_map(coords - tilemap_layer.global_position)
		var tile_data = tilemap_layer.get_cell_tile_data(local_coords)
		if tile_data:
			return tile_data
	print("ERROR: No areas has this point" + str(coords))
	return TileData.new()
