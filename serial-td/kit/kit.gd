extends CharacterBody2D

var baseTower = preload("res://tower/base_tower.tscn")

const speed: float = 300.0
var inputDirection: Vector2
var moving: bool = false
var tileSize: int = 16

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and not moving:
		var tower = baseTower.instantiate()
		get_node('/root/World').add_child(tower)
		# TODO(Ben): Add ability to choose where tower is placed
		tower.global_position = position + Vector2(0,1) * tileSize

	# TODO(Hop): Make sure movement is /somewhat/ aligned to the grid?
	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("ui_down"):
		inputDirection = Vector2(0,1)
		_move()
	if Input.is_action_pressed("ui_up"):
		inputDirection = Vector2(0,-1)
		_move()
	if Input.is_action_pressed("ui_left"):
		inputDirection = Vector2(-1,0)
		_move()
	if Input.is_action_pressed("ui_right"):
		inputDirection = Vector2(1,0)
		_move()

	move_and_slide()
	
func _move() -> void:
	if inputDirection:
		if not moving:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + inputDirection * tileSize, 0.1)
			tween.tween_callback(move_false)

func move_false() -> void:
	moving = false
