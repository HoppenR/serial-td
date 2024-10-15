extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world_roguelike/world.tscn")
