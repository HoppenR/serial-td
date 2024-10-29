extends "res://enemy/baseenemy.gd"

var previous_position = Vector2(0, 0)

func _process(delta):
	var direction = global_position - previous_position
	if direction.x > 0:
		$Sprite.flip_h = true
	elif direction.x < 0:
		$Sprite.flip_h = false
	previous_position = global_position
