extends Sprite2D

var damage: int
var life_timer

var main_element
var secondary_element

func _ready() -> void:
	main_element = gamedata.damage_type.FIRE
	
	damage = gamedata.damage_data[main_element]["damage"]
	get_parent().speed *= gamedata.damage_data[main_element]["speed_debuff"]
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(gamedata.damage_data[main_element]["damage_frequency"])
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.connect("timeout", _remove_effect)
	add_child(life_timer)
	life_timer.start(gamedata.damage_data[main_element]["duration"])

func _deal_damage() -> void:
	get_parent().take_damage(damage, gamedata.damage_type.FIRE)

func _remove_effect() -> void:
	var my_parent = get_parent()
	if not my_parent:
		return
	my_parent.speed /= gamedata.damage_data[main_element]["speed_debuff"]
	my_parent.active_effects.erase(self)
	queue_free()
