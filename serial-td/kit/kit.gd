extends CharacterBody2D

var baseTower = preload("res://tower/base_tower.tscn")
@onready var tileMap: TileMapLayer = $"../PlayerTraversal"

var inputDirection: Vector2
var prevInputDirection: Vector2

var moving: bool = false
var tileSize: int = 16

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and not moving:
		var tower = baseTower.instantiate()
		get_node('/root/World').add_child(tower)
		# TODO(Ben): Improve ability to choose where tower is placed (i.e maybe in a grid-like circle around kit)
		tower.global_position = position + prevInputDirection * tileSize

	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if inputDirection:
		prevInputDirection = inputDirection
		if Input.is_action_pressed("ui_down"):
			inputDirection = Vector2.DOWN
			_move()
		if Input.is_action_pressed("ui_up"):
			inputDirection = Vector2.UP
			_move()
		if Input.is_action_pressed("ui_left"):
			inputDirection = Vector2.LEFT
			_move()
		if Input.is_action_pressed("ui_right"):
			inputDirection = Vector2.RIGHT
			_move()
	move_and_slide()
	
func _move() -> void:
	var currentTile: Vector2i = tileMap.local_to_map(global_position)
	var targetTile: Vector2i = Vector2i(
		currentTile.x + inputDirection.x,
		currentTile.y + inputDirection.y,
	)
	var tileData: TileData = tileMap.get_cell_tile_data(targetTile)
	
	if not tileData.get_custom_data("walkable"):
		return
		
	if not moving:
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputDirection * tileSize, 0.1)
		tween.tween_callback(move_false)

func move_false() -> void:
	moving = false
