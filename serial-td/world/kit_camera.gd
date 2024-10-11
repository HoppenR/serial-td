extends Camera2D

#signal area_changed(new_position: Area2D)
@onready var world = get_tree().root.get_node("World")

var cur_screen: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchor_mode(ANCHOR_MODE_FIXED_TOP_LEFT)
	world.connect("area_changed", _area_changed)

func _area_changed(new_area: Vector2i):
	position = new_area
