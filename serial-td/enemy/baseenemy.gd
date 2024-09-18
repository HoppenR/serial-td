extends PathFollow2D

var speed = 150

func _physics_process(delta: float) -> void:
	_move(delta)
	if get_progress() == 1:
		queue_free()

func _move(delta: float) -> void:
	set_progress(get_progress() + speed * delta)
