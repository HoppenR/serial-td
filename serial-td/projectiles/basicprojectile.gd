extends Node2D

var speed: float = 15
var lifeTime: float = 2.0
var damage: int = 3
var pierce: int = 5

var clockTicking: bool = false

func _physics_process(delta: float) -> void:
	_shoot()
	if not clockTicking:
		_start_life()

func _start_life() -> void:
	clockTicking = true
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _kill_self)
	timer.start(lifeTime)

func _shoot() -> void:
	position += transform.x * speed
	
func _kill_self() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name != "Kit":
		pierce -= 1
		body.get_parent().take_damage(damage)
		if pierce < 1:
			queue_free()
