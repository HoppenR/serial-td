extends Node2D

var projectileload = preload("res://projectiles/basicprojectile.tscn")
var shootSpeed: float = 0.1
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

	projectile.damage = 3
	projectile.pierce = 3
	projectile.speed = 15.0
	projectile.lifeTime = 1.0

	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _become_ready)
	timer.start(shootSpeed)
	
func _become_ready() -> void:
	isReady = true

func _on_range_body_entered(body) -> void:
	if body.name != "Kit":
		enemyArray.append(body.get_parent())

func _on_range_body_exited(body) -> void:
	enemyArray.erase(body.get_parent())
