extends Control

var tower
var node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tower:
		$TextureRect.texture = gamedata.tower_data[tower]["texture"]
		$CostLabel.text = "$" + str(gamedata.tower_data[tower]["cost"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_interact"):
		if node:
			if get_parent()._fully_place_tower(tower):
				node.queue_free()
				queue_free()
