extends Area2D

var damage: int

var projectileload
var life_timer

var element

var enemy_array = []

func _ready() -> void:
	element = gamedata.damage_type.ELECTRICITY_ICE
	damage = gamedata.damage_data[element]["damage"]
	get_parent().shocked = true
	get_parent().frozen = true
	get_parent().speed *= gamedata.damage_data[element]["speed_debuff"]
	$RangeCollision.shape.radius = gamedata.damage_data[element]["range"]
	projectileload = preload("res://projectiles/electricprojectile.tscn")
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(gamedata.damage_data[element]["damage_frequency"])
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.connect("timeout", _remove_effect)
	add_child(life_timer)
	life_timer.start(gamedata.damage_data[element]["duration"])

func _deal_damage() -> void:
	for i in range(enemy_array.size()):
		enemy_array[i].take_damage(damage, element)

func _on_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())

func _remove_effect() -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	my_parent.shocked = false
	my_parent.frozen = false
	my_parent.speed /= gamedata.damage_data[element]["speed_debuff"]
	my_parent.active_effects.erase(self)
	queue_free()

func _react_to_element(damage_type) -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	match damage_type:
		gamedata.damage_type.FIRE:
			_remove_effect()
