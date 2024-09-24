extends CharacterBody2D

var baseTower = preload("res://towers/base/baset1.tscn")
@onready var tileMap: TileMapLayer = $"../PlayerTraversal"

var input_direction: Vector2
var prev_input_direction: Vector2 = Vector2.UP

var moving: bool = false
var tileSize: int = 16
var tower_placement_range: int = 32
var tower

var dragging: bool = false

func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction:
		prev_input_direction = input_direction
		if Input.is_action_pressed("ui_down"):
			input_direction = Vector2.DOWN
			_move()
		if Input.is_action_pressed("ui_up"):
			input_direction = Vector2.UP
			_move()
		if Input.is_action_pressed("ui_left"):
			input_direction = Vector2.LEFT
			_move()
		if Input.is_action_pressed("ui_right"):
			input_direction = Vector2.RIGHT
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

# Make exclusive tile type placements for towers,
# i.e, make some towers have the ability to be placed
# on water, while others not
func _place_tower(towerToPlace) -> void:
	var placeOffset: Vector2 = _get_next_tile(prev_input_direction)
	var next_tile: Vector2i = tileMap.local_to_map(Vector2(global_position.x + placeOffset.x, global_position.y + placeOffset.y + tileSize / 2))
	var tile_data: TileData = tileMap.get_cell_tile_data(next_tile)

	# Change to placeable
	if not tile_data or not tile_data.get_custom_data("walkable"):
		return
	
	towerToPlace.global_position = position + placeOffset

func _move() -> void:
	if moving:
		return

	var move_offset: Vector2 = _get_next_tile(input_direction)	
	var next_tile: Vector2i = tileMap.local_to_map(Vector2(global_position.x + move_offset.x, global_position.y + move_offset.y + tileSize / 2))
	
	var tile_data: TileData = tileMap.get_cell_tile_data(next_tile)
	
	if not tile_data or not tile_data.get_custom_data("walkable"):
		return
	
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_offset, 0.1)
	tween.connect("finished", _move_false)

func _move_false() -> void:
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
