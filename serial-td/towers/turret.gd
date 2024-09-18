extends Node2D

var projectileload = preload("res://projectiles/basicprojectile.tscn")
var shootSpeed: float = 1.0
var isReady: bool = true

func _physics_process(delta: float) -> void:
	#_turn()
	if isReady:
		_shoot()

func _turn() -> void:
	var targetPosition = get_global_mouse_position()
	get_node("Sprite").look_at(targetPosition)

func _shoot() -> void:
	isReady = false
	var projectile = projectileload.instantiate()
	add_child(projectile)
	projectile.look_at(get_global_mouse_position())
	projectile.global_position = global_position

	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _become_ready)
	timer.start(shootSpeed)
	
func _become_ready() -> void:
	isReady = true
