extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["damage_frequency"] /= 2
	print("Upgrade applied")
	queue_free()
