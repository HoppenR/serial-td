extends PathFollow2D

var speed: int = 150
var hp: int = 2


# Use for elemental interractions?
var on_fire: bool = false
var fire_timer

var frozen: bool = false
var freeze_timer

func _ready() -> void:
	# Use Kit's `_enemy_dead` handler
	var kit_node = get_tree().get_root().get_node("World/Kit")
	$Hitbox.add_collision_exception_with(kit_node)
	connect("tree_exiting", kit_node._enemy_dead)
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
		# take damage here?
		get_parent().enemies_alive.erase(self)
		queue_free()

func _move(delta: float) -> void:
	set_progress(get_progress() + speed * delta)

func take_damage(amount: int, damage_type) -> void:
	if on_fire:
		amount *= 2

	match damage_type:
		gamedata.damage_type.FIRE:
			if not on_fire:
				on_fire = true
				fire_timer.start(0.3)
		gamedata.damage_type.ICE:
			if not frozen and not on_fire:
				frozen = true
				freeze_timer.start(4.5)
				speed /= 4

	hp -= amount
	if hp < 1:
		#emit_signal("enemy_died")
		get_parent().enemies_alive.erase(self)
		queue_free()
		return

func _extinquish() -> void:
	on_fire = false
	
func _thaw() -> void:
	frozen = false
	speed *= 4
