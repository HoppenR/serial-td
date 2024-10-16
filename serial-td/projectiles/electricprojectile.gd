extends "res://projectiles/projectilebase.gd"

func _init() -> void:
	projectile_type = gamedata.damage_type.ELECTRICITY

func _on_hitbox_body_entered(body: Node2D) -> void:
	pierce -= 1
	body.get_parent().take_damage(damage, projectile_type)
	if pierce < 1:
		queue_free()
