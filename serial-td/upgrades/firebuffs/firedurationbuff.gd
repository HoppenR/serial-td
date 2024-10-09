extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamedata.damage_data[gamedata.damage_type.FIRE]["duration"] *= 2
	print("Upgrade applied")
	queue_free()
