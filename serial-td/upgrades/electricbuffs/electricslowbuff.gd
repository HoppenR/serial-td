extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["speed_debuff"] *= 0.9
	print("Upgrade applied")
	queue_free()