extends PathFollow2D

var speed: int = 150
var hp: int = 2

signal enemy_dead(deal_damage: bool, enemy_hp: int)

var active_effects = []

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
	var effect
	if not _find_if_element(damage_type):
		match damage_type:
			gamedata.damage_type.FIRE:
					effect = gamedata.fire.instantiate()
			gamedata.damage_type.ICE:
					effect = gamedata.frozen.instantiate()
			gamedata.damage_type.ELECTRICITY:
					effect = gamedata.electricfield.instantiate()
			gamedata.damage_type.WATER:
					effect = gamedata.wet.instantiate()
		for current_effect in active_effects:
			ElementalInteraction._react_to_element(current_effect, self, current_effect.main_element, damage_type)
			ElementalInteraction._react_to_element(current_effect, self, current_effect.secondary_element, damage_type)
		if effect:
			_add_effect(effect)

	hp -= amount
	if hp < 1:
		emit_signal("enemy_dead", false, 0)
		get_parent().enemies_alive.erase(self)
		queue_free()
		return

func _remove_element(damage_type) -> void:
	for current_effect in active_effects:
		if current_effect.main_element == damage_type or current_effect.secondary_element == damage_type:
			current_effect._remove_effect();

func _add_effect(effect) -> void:
	call_deferred("add_child", effect)
	active_effects.push_back(effect)

func _find_if_element(damage_type) -> bool:
	for current_effect in active_effects:
		if current_effect.main_element == damage_type or current_effect.secondary_element == damage_type:
			return true
	return false
