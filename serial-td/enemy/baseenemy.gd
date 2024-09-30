extends PathFollow2D

var speed: int = 150
var hp: int = 2

signal enemy_dead(deal_damage: bool, enemy_hp: int)

# Use for elemental interractions?
var on_fire: bool = false
var fire_timer

var frozen: bool = false
var freeze_timer

var shocked: bool = false

func _ready() -> void:
	# Use Kit's `_enemy_dead` handler
	var kit_node = get_tree().get_root().get_node("World/Kit")
	$Hitbox.add_collision_exception_with(kit_node)
	connect("enemy_dead", kit_node._enemy_dead)
	fire_timer = Timer.new()
	freeze_timer = Timer.new()
	fire_timer.one_shot = true
	freeze_timer.one_shot = true
	add_child(fire_timer)
	add_child(freeze_timer)
	fire_timer.connect("timeout", _extinquish)
	freeze_timer.connect("timeout", _thaw)

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
				on_fire = true
				fire_timer.start(0.3)
				var fire = gamedata.fire.instantiate()
				fire.damage = amount
				call_deferred("add_child", fire)
				if frozen:
					freeze_timer.stop()
					_thaw()
		gamedata.damage_type.ICE:
			if not frozen and not on_fire:
				frozen = true
				freeze_timer.start(4.5)
				var ice = gamedata.frozen.instantiate()
				call_deferred("add_child", ice)
				speed *= 0.25
		gamedata.damage_type.ELECTRICITY:
			if not shocked:
				shocked = true
				var field = gamedata.electricfield.instantiate()
				field.damage = amount
				call_deferred("add_child", field)
				speed *= 0.7
			
	hp -= amount
	if hp < 1:
		emit_signal("enemy_dead", false, 0)
		get_parent().enemies_alive.erase(self)
		queue_free()
		return

func _extinquish() -> void:
	on_fire = false
	$Fire.queue_free()

func _thaw() -> void:
	frozen = false
	speed *= 4
	$Frozen.queue_free()
