extends Control


@onready var tower = $SelectedTower

var tower_textures = [
	preload("res://assets/gun2.png"),
	preload("res://assets/gun.png"),
]

# NOTE: Indended to be called via signals from `res://kit/kit.gd`
func _update_selected_tower(currentTower: int):
	print("new tower", currentTower)
	tower.texture = tower_textures[currentTower]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower.texture = tower_textures[0]
	var kit_node = get_tree().get_root().get_node("World/Kit")
	kit_node.connect("tower_changed", _update_selected_tower)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
