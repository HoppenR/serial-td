extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.health += 40
	print("Upgrade applied")
	queue_free()
