extends Control

@onready var tower = $TowerPanel/SelectedTower
@onready var tower_cost = $TowerPanel/CostLabel
@onready var gold_text = $InfoPanel/GoldIcon/GoldLabel
@onready var health_text = $InfoPanel/HealthIcon/HealthLabel

# NOTE: Indended to be called via signals from `res://kit/kit.gd`
func _update_selected_tower(currentTower, cost: int):
	tower.texture = gamedata.tower_data[currentTower]["texture"]
	tower_cost.text = "Cost: " + str(cost)
	

func _update_gold_count(new_amount: int):
	gold_text.text = str(Global.gold)

func _update_health_amount(new_health: int):
	health_text.text = str(new_health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Selected tower preview
	var kit_node = get_tree().get_root().get_node("World/Kit")
	kit_node.connect("tower_changed", _update_selected_tower)
	Global.connect("gold_changed", _update_gold_count)
	Global.connect("health_changed", _update_health_amount)
	_update_gold_count(Global.gold)
	_update_health_amount(Global.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
