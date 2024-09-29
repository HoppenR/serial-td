extends TileMapLayer

var last_tile: Variant = null

func _select_tile(tile_position: Vector2i):
	if last_tile:
		if last_tile != tile_position:
			set_cell(last_tile, -1, Vector2i(0, 0), 0)
			last_tile = tile_position
			set_cell(tile_position, 0, Vector2i(0, 0), 0)
	else:
		last_tile = tile_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var kit_node = get_tree().get_root().get_node("World/Kit")
	kit_node.connect("select_tile", _select_tile)
