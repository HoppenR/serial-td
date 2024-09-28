extends PathFollow2D

var speed: int = 150
var hp: int = 2

# Use for elemental interractions?
var on_fire: bool = false

func _ready() -> void:
	# Use Kit's `_enemy_dead` handler
	var kit_node = get_tree().get_root().get_node("World/Kit")
	$Hitbox.add_collision_exception_with(kit_node)
	connect("tree_exiting", kit_node._enemy_dead)

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
			on_fire = true
			var timer = Timer.new()
			add_child(timer)
			timer.one_shot = true
			timer.connect("timeout", _extinquish)
			timer.start(0.3)

	hp -= amount
	if hp < 1:
		#emit_signal("enemy_died")
		get_parent().enemies_alive.erase(self)
		queue_free()
		return

func _extinquish() -> void:
	on_fire = false
