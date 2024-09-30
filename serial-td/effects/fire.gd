extends Sprite2D

var damage: int

func _ready() -> void:
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(0.5)

func _deal_damage() -> void:
	get_parent().take_damage(damage, gamedata.damage_type.FIRE)
