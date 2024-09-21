extends PathFollow2D

var speed = 150
var hp = 2

func _physics_process(delta: float) -> void:
	_move(delta)
	if get_progress() == 1:
		get_parent().queue_free()

func _move(delta: float) -> void:
	set_progress(get_progress() + speed * delta)

func take_damage(amount: int) -> void:
	hp -= amount
	if hp < 1:
		queue_free()
