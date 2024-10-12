extends Sprite2D

var damage: int
var life_timer

var main_element
var secondary_element

var slow

func _ready() -> void:
	main_element = gamedata.damage_type.ELECTRICITY
	secondary_element = gamedata.damage_type.WATER
	ElementalInteraction._init_effect(self)

func _deal_damage() -> void:
	get_parent().take_damage(damage, main_element)

func _remove_effect() -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	my_parent.speed /= slow
	my_parent.active_effects.erase(self)
	queue_free()
