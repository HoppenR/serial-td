extends Area2D

var damage: int

var projectileload
var life_timer

var enemy_array = []

func _ready() -> void:
	damage = gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["damage"]
	get_parent().shocked = true
	get_parent().speed *= gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["speed_debuff"]
	$RangeCollision.shape.radius = gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["range"]
	projectileload = preload("res://projectiles/electricprojectile.tscn")
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["damage_frequency"])
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.connect("timeout", _remove_effect)
	add_child(life_timer)
	life_timer.start(gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["duration"])

func _deal_damage() -> void:
	for i in range(enemy_array.size()):
		enemy_array[i].take_damage(damage, gamedata.damage_type.ELECTRICITY)


func _on_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())

func _remove_effect() -> void:
	get_parent().shocked = false
	get_parent().speed /= gamedata.damage_data[gamedata.damage_type.ELECTRICITY]["speed_debuff"]
	queue_free()
