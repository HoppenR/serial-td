extends Node2D

@onready var levels_node = Node2D.new()

signal stage_changed()
signal area_changed(new_area: Vector2i)

var current_level_node: Node2D

var current_level: int = 1:
	set(new_value):
		var next_level = load("res://world_roguelike/levels/level" + str(new_value) + ".tscn").instantiate()
		current_level = new_value
		current_level_node.queue_free()
		current_level_node = next_level
		add_child(current_level_node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("stage_changed", _next_level)
	var lv1 = preload("res://world_roguelike/levels/level1.tscn").instantiate()
	current_level_node = lv1
	add_child(lv1)

func _next_level():
	Global.heat += 0.3
	current_level += 1

func get_cell_tile_data(coords: Vector2) -> TileData:
	# First check for the level that should be visible previously
	var tilemap_layer: TileMapLayer = current_level_node.get_node("PlayerTraversal")
	var local_coords: Vector2i = tilemap_layer.local_to_map(coords - tilemap_layer.global_position)
	var tile_data: TileData = tilemap_layer.get_cell_tile_data(local_coords)
	return tile_data
