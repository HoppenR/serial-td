extends Sprite2D

var damage: int
var life_timer

func _ready() -> void:
	damage = gamedata.damage_data[gamedata.damage_type.FIRE]["damage"]
	get_parent().on_fire = true
	get_parent().speed *= gamedata.damage_data[gamedata.damage_type.FIRE]["speed_debuff"]
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(gamedata.damage_data[gamedata.damage_type.FIRE]["damage_frequency"])
	life_timer = Timer.new()
	life_timer.one_shot = true
	life_timer.connect("timeout", _remove_effect)
	add_child(life_timer)
	life_timer.start(gamedata.damage_data[gamedata.damage_type.FIRE]["duration"])

func _deal_damage() -> void:
	get_parent().take_damage(damage, gamedata.damage_type.FIRE)

func _remove_effect() -> void:
	get_parent().on_fire = false
	get_parent().speed /= gamedata.damage_data[gamedata.damage_type.FIRE]["speed_debuff"]
	queue_free()
