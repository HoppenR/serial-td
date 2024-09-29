extends "res://projectiles/projectilebase.gd"

func _init() -> void:
	lifetime = 1.0
	speed = 1.0
	damage = 1
	pierce = 1
	projectile_type = gamedata.damage_type.STANDARD
