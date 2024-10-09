extends PathFollow2D

var speed: int = 150
var hp: int = 2

signal enemy_dead(deal_damage: bool, enemy_hp: int)

# Use for elemental interractions?
var on_fire: bool = false
var frozen: bool = false
var shocked: bool = false

func _ready() -> void:
	# Use Kit's `_enemy_dead` handler
	var kit_node = get_tree().get_root().get_node("World/Kit")
	$Hitbox.add_collision_exception_with(kit_node)
	connect("enemy_dead", kit_node._enemy_dead)

func _physics_process(delta: float) -> void:
	_move(delta)
	if progress_ratio == 1:
		emit_signal("enemy_dead", true, hp)
		get_parent().enemies_alive.erase(self)
		queue_free()

func _move(delta: float) -> void:
	set_progress(get_progress() + speed * delta)

func take_damage(amount: int, damage_type) -> void:
	match damage_type:
		gamedata.damage_type.FIRE:
			if not on_fire:
				var fire = gamedata.fire.instantiate()
				call_deferred("add_child", fire)
		gamedata.damage_type.ICE:
			if not frozen and not on_fire:
				var ice = gamedata.frozen.instantiate()
				call_deferred("add_child", ice)
		gamedata.damage_type.ELECTRICITY:
			if not shocked:
				var field = gamedata.electricfield.instantiate()
				call_deferred("add_child", field)

	hp -= amount
	if hp < 1:
		emit_signal("enemy_dead", false, 0)
		get_parent().enemies_alive.erase(self)
		queue_free()
		return
