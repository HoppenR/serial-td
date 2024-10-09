extends Sprite2D

var damage: int
var life_timer

func _ready() -> void:
	damage = gamedata.damage_data[gamedata.damage_type.ICE]["damage"]
	get_parent().frozen = true
	get_parent().speed *= gamedata.damage_data[gamedata.damage_type.ICE]["speed_debuff"]
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(gamedata.damage_data[gamedata.damage_type.ICE]["damage_frequency"])
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.connect("timeout", _remove_effect)
	add_child(life_timer)
	life_timer.start(gamedata.damage_data[gamedata.damage_type.ICE]["duration"])

func _deal_damage() -> void:
	get_parent().take_damage(damage, gamedata.damage_type.ICE)

func _remove_effect() -> void:
	get_parent().frozen = false
	get_parent().speed /= gamedata.damage_data[gamedata.damage_type.ICE]["speed_debuff"]
	queue_free()