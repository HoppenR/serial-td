extends TileMapLayer

var last_tile: Variant = null

func _select_tile(tile_position: Vector2i):
	match typeof(last_tile):
		TYPE_NIL:
			last_tile = tile_position
		TYPE_VECTOR2I:
			if last_tile != tile_position:
				set_cell(last_tile, -1, Vector2i(0, 0), 0)
				last_tile = tile_position
				set_cell(tile_position, 0, Vector2i(0, 0), 0)

func reset_kit() -> void:
	var kit_node = get_tree().get_root().get_node("World/Kit")
	kit_node.connect("select_tile", _select_tile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_kit()
