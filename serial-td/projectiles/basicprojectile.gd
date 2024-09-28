extends Node2D

var lifetime: float = 1.0 
var speed: float = 1.0
var damage: int = 1
var pierce: int = 1

var projectile_type = gamedata.projectile_types.STANDARD;

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
	if body.name != "Kit":
		pierce -= 1
		body.get_parent().take_damage(damage)
		if pierce < 1:
			queue_free()
