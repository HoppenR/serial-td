extends Node2D

var speed: float = 15
var lifeTime: float = 2.0

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
