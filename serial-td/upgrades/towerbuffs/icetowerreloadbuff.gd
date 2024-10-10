extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamedata.tower_data[gamedata.towers.ICE_T0]["reload_time"] /= 2
	print("Upgrade applied")
	queue_free()
