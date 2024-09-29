extends Node2D

var lifetime: float
var speed: float
var damage: int
var pierce: int

var projectile_type

func _ready() -> void:
	_start_life()

func _physics_process(delta: float) -> void:
	_shoot()

func _start_life() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _kill_self)
	timer.start(lifetime)

func _shoot() -> void:
	position += transform.x * speed

func _kill_self() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	pierce -= 1
	body.get_parent().take_damage(damage, projectile_type)
	if pierce < 1:
		queue_free()
