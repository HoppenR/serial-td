extends Node2D

var projectileload = preload("res://projectiles/basicprojectile.tscn")
var reload_time: float = 0.1
var bullet_speed: int = 100
var damage: int = 1
var isReady: bool = true

var targetPosition: Vector2

var enemyArray = []

func _physics_process(delta: float) -> void:
	_turn()
	if isReady and not enemyArray.is_empty():
		_shoot()

func _turn() -> void:
	if not enemyArray.is_empty():
		targetPosition = enemyArray[0].global_position
	
	get_node("Sprite").look_at(targetPosition)

func _shoot() -> void:
	isReady = false
	if not enemyArray.is_empty():
		targetPosition = enemyArray[0].global_position
		
	var projectile = projectileload.instantiate()
	add_child(projectile)
	projectile.look_at(targetPosition)
	projectile.global_position = global_position

	projectile.damage = damage
	projectile.pierce = 3
	projectile.speed = bullet_speed
	projectile.lifeTime = 1.0

	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _become_ready)
	timer.start(reload_time)
	
func _become_ready() -> void:
	isReady = true

func _on_range_body_entered(body) -> void:
	if body.name != "Kit":
		enemyArray.append(body.get_parent())

func _on_range_body_exited(body) -> void:
	enemyArray.erase(body.get_parent())
