extends "res://towers/turret.gd"

#Ice T0

func _init() -> void:
	projectileload = preload("res://projectiles/iceprojectile.tscn")
	reload_time = 0.1
	bullet_speed = 100
	damage = 1
	range = 10
	pierce = 1 
	bullet_lifetime = 1.0
