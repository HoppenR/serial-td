extends CharacterBody2D

var baseTower = preload("res://towers/base/baset1.tscn")
@onready var tileMap: TileMapLayer = $"../PlayerTraversal"

var inputDirection: Vector2
var prevInputDirection: Vector2

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
			_placeTower(tower)
		if dragging and not event.pressed:
			dragging = false
		
	if event is InputEventMouseMotion and dragging and not moving:
		_placeTower(tower)

func _placeTower(towerToPlace) -> void:
	var placeOffset
	if prevInputDirection == Vector2.RIGHT:
		placeOffset = Vector2(tileSize, tileSize / 2)
	elif prevInputDirection == Vector2.UP:
		placeOffset = Vector2(tileSize, -tileSize / 2)
	elif prevInputDirection == Vector2.LEFT:
		placeOffset = Vector2(-tileSize, -tileSize / 2)
	elif prevInputDirection == Vector2.DOWN:
		placeOffset = Vector2(-tileSize, tileSize / 2)
	towerToPlace.global_position = position + placeOffset

func _move() -> void:
	var currentTile: Vector2i = tileMap.local_to_map(global_position)
	var targetTile: Vector2i = Vector2i(
		currentTile.x + inputDirection.x,
		currentTile.y + inputDirection.y,
	)
	var tileData: TileData = tileMap.get_cell_tile_data(targetTile)
	
	if not tileData.get_custom_data("walkable"):
		return
		
	var moveOffset
	if inputDirection == Vector2.RIGHT:
		moveOffset = Vector2(tileSize, tileSize / 2)
	elif inputDirection == Vector2.UP:
		moveOffset = Vector2(tileSize, -tileSize / 2)
	elif inputDirection == Vector2.LEFT:
		moveOffset = Vector2(-tileSize, -tileSize / 2)
	elif inputDirection == Vector2.DOWN:
		moveOffset = Vector2(-tileSize, tileSize / 2)
		
	if not moving:
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + moveOffset, 0.1)
		tween.tween_callback(move_false)

func move_false() -> void:
	moving = false
