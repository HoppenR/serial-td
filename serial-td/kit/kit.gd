extends CharacterBody2D

var baseTower = preload("res://towers/base/baset1.tscn")
@onready var tileMap: TileMapLayer = $"../PlayerTraversal"

var inputDirection: Vector2
var prevInputDirection: Vector2 = Vector2.UP

var moving: bool = false
var tileSize: int = 16
var towerPlacementRange: int = 32
var tower

var dragging: bool = false

func _physics_process(delta: float) -> void:
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

func _input(event) -> void:
	if event is InputEventMouseButton and not moving:
		if not dragging and event.pressed:
			dragging = true
			tower = baseTower.instantiate()
			get_parent().add_child(tower)
			_place_tower(tower)
		if dragging and not event.pressed:
			dragging = false
		
	if event is InputEventMouseMotion and dragging and not moving:
		_place_tower(tower)

func _place_tower(towerToPlace) -> void:
	var placeOffset: Vector2 = _get_next_tile(prevInputDirection)
	towerToPlace.global_position = position + placeOffset

func _move() -> void:
	if moving:
		return

	var moveOffset: Vector2 = _get_next_tile(inputDirection)	
	var nextTile: Vector2i = tileMap.local_to_map(Vector2(global_position.x + moveOffset.x, global_position.y + moveOffset.y + tileSize / 2))
	
	var tileData: TileData = tileMap.get_cell_tile_data(nextTile)
	
	if not tileData or not tileData.get_custom_data("walkable"):
		return
	
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + moveOffset, 0.1)
	tween.connect("finished", move_false)

func move_false() -> void:
	moving = false

func _get_next_tile(direction: Vector2) -> Vector2:
	var offset
	if direction == Vector2.RIGHT:
		offset = Vector2(tileSize, tileSize / 2)
	elif direction == Vector2.UP:
		offset = Vector2(tileSize, -tileSize / 2)
	elif direction == Vector2.LEFT:
		offset = Vector2(-tileSize, -tileSize / 2)
	elif direction == Vector2.DOWN:
		offset = Vector2(-tileSize, tileSize / 2)
	return offset;
