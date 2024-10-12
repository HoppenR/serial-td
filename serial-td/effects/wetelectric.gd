extends Sprite2D

var damage: int
var life_timer

var element

func _ready() -> void:
	element = gamedata.damage_type.ELECTRICITY_WATER
	damage = gamedata.damage_data[element]["damage"]
	get_parent().wet = true
	get_parent().shocked = true
	get_parent().speed *= gamedata.damage_data[element]["speed_debuff"]
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
	get_parent().take_damage(damage, gamedata.damage_type.FIRE)

func _remove_effect() -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	my_parent.wet = false
	my_parent.shocked = false
	my_parent.speed /= gamedata.damage_data[element]["speed_debuff"]
	my_parent.active_effects.erase(self)
	queue_free()

func _react_to_element(damage_type) -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	match damage_type:
		gamedata.damage_type.FIRE:
			my_parent._remove_element(damage_type)
		gamedata.damage_type.ICE:
			my_parent._remove_element(damage_type)
			var effect = gamedata.electric_ice.instantiate()
			my_parent._add_effect(effect)
			_remove_effect()
