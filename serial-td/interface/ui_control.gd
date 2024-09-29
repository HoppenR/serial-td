extends Control


@onready var tower = $SelectedTower
@onready var gold_text = $InfoPanel/GoldLabel
@onready var health_text = $InfoPanel/HealthLabel

var tower_textures = [
	preload("res://assets/towers/gun.png"),
	preload("res://assets/towers/gun2.png"),
	preload("res://assets/towers/flamet0.png"),
	preload("res://assets/towers/icet0.png"),
	preload("res://assets/towers/electrict0.png"),
]

# NOTE: Indended to be called via signals from `res://kit/kit.gd`
func _update_selected_tower(currentTower: int):
	tower.texture = tower_textures[currentTower]

func _update_gold_count(new_amount: int):
	gold_text.text = "Gold: " + str(new_amount)

func _update_health_amount(new_health: int):
	health_text.text = "Life: " + str(new_health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Selected tower preview
	var kit_node = get_tree().get_root().get_node("World/Kit")
	kit_node.connect("tower_changed", _update_selected_tower)
	kit_node.connect("gold_changed", _update_gold_count)
	kit_node.connect("health_changed", _update_health_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
