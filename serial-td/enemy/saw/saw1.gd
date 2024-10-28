extends "res://enemy/baseenemy.gd"

var previous_position = Vector2(0, 0)

func _ready():
	$Sprite.texture = $Sprite.texture.duplicate()

func _process(delta):
	var direction = global_position - previous_position
	if direction.x > 0 and direction.y < 0:
		$Sprite.texture.region.position = Vector2(64, 32)
	elif direction.x > 0 and direction.y > 0:
		$Sprite.texture.region.position = Vector2(64, 0)
	elif direction.x < 0 and direction.y < 0:
		$Sprite.texture.region.position = Vector2(32, 32)
	elif direction.x < 0 and direction.y > 0:
		$Sprite.texture.region.position = Vector2(32, 0)
	previous_position = global_position
