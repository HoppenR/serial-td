extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.heat -= 0.2
	print("Upgrade applied")
	queue_free()
