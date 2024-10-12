extends Area2D

var damage: int

var projectileload
var life_timer

var main_element
var secondary_element

var slow

var enemy_array = []

func _ready() -> void:
	main_element = gamedata.damage_type.ELECTRICITY
	secondary_element = gamedata.damage_type.ICE
	$RangeCollision.shape.radius = gamedata.damage_data[main_element]["range"]
	ElementalInteraction._init_effect(self)

func _deal_damage() -> void:
	for i in range(enemy_array.size()):
		enemy_array[i].take_damage(damage, main_element)

func _on_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())

func _remove_effect() -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	my_parent.speed /= slow
	my_parent.active_effects.erase(self)
	queue_free()
