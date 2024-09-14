extends CharacterBody2D


const SPEED = 300.0
var baseTower = preload("res://tower/base_tower.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var tower = baseTower.instantiate()
		get_node('/root/World').add_child(tower)
		# TODO(Hop): Make sure the placement snaps to grid
		tower.global_position = position

	# TODO(Hop): Make sure movement is /somewhat/ aligned to the grid?
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0.0, 0.0)

	move_and_slide()
