extends Node2D

var projectileload

var reload_time: float
var bullet_speed: int
var damage: int
var range: int
var pierce: int 
var bullet_lifetime: float

var is_ready: bool = true
var target_position: Vector2

var enemy_array = []

func _ready() -> void:
	$Range/RangeCollision.shape.radius = range 

func _physics_process(delta: float) -> void:
	_turn()
	if is_ready and not enemy_array.is_empty():
		_shoot()

func _turn() -> void:
	if not enemy_array.is_empty():
		target_position = enemy_array[0].global_position
	
	get_node("Sprite").look_at(target_position)

func _shoot() -> void:
	is_ready = false
	if not enemy_array.is_empty():
		target_position = enemy_array[0].global_position
		
	var projectile = projectileload.instantiate()

	add_child(projectile)

	projectile.damage = damage
	projectile.pierce = pierce
	projectile.speed = bullet_speed
	projectile.lifetime = bullet_lifetime

	projectile.look_at(target_position)
	projectile.global_position = global_position


	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _become_ready)
	timer.start(reload_time)
	
func _become_ready() -> void:
	is_ready = true

func _on_range_body_entered(body: Node2D) -> void:
	#If not kit
	if body != get_tree().get_root().get_node("World/Kit"):
		enemy_array.append(body.get_parent())

func _on_range_body_exited(body) -> void:
	enemy_array.erase(body.get_parent())
