extends CharacterBody2D

var baseTower = preload("res://tower/base_tower.tscn")
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
			get_node('/root/World').add_child(tower)
			_placeTower(tower)
		if dragging and not event.pressed:
			dragging = false
		
	if event is InputEventMouseMotion and dragging and not moving:
		_placeTower(tower)

func _placeTower(towerToPlace) -> void:
	var mousePos: Vector2i = get_global_mouse_position()
	mousePos = Vector2((mousePos.x - mousePos.x % tileSize) - tileSize / 2,
					   (mousePos.y - mousePos.y % tileSize) + tileSize / 2)
	if mousePos.x > position.x + towerPlacementRange:
		mousePos.x = position.x + towerPlacementRange
	if mousePos.x < position.x - towerPlacementRange:
		mousePos.x = position.x - towerPlacementRange
	if mousePos.y > position.y + towerPlacementRange:
		mousePos.y = position.y + towerPlacementRange
	if mousePos.y < position.y - towerPlacementRange:
		mousePos.y = position.y - towerPlacementRange
	if mousePos != Vector2i(position):
		towerToPlace.global_position = mousePos

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
