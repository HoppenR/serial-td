extends CharacterBody2D

var base_towers = [
	"baset0",
	"baset1",
	"firet0",
	"icet0",
	"electrict0",
]

var health: int = 3

@onready var tilemap: TileMapLayer = $"../PlayerTraversal"

var raycast

var current_tower: int = 0
var gold: int = 500

# NOTE: `res://interface/ui_control.gd`
signal tower_changed(new_tower: int)
signal gold_changed(new_gold: int)
signal health_changed(new_health: int)
# NOTE: `res://path/tilemap.gd`
signal select_tile(position: Vector2)

var input_direction: Vector2
var previous_input_direction: Vector2 = Vector2.UP

var moving: bool = false
var tile_size: int = 16
var tower_placement_range: int = 32
var tower

func _ready() -> void:
	raycast = $Raycast

func _physics_process(delta: float) -> void:
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_direction:
		previous_input_direction = input_direction

	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction:
		previous_input_direction = input_direction
		if Input.is_action_pressed("ui_down"):
			input_direction = Vector2.DOWN
			_move()
		elif Input.is_action_pressed("ui_up"):
			input_direction = Vector2.UP
			_move()
		elif Input.is_action_pressed("ui_left"):
			input_direction = Vector2.LEFT
			_move()
		elif Input.is_action_pressed("ui_right"):
			input_direction = Vector2.RIGHT
			_move()
		
	if Input.is_action_just_pressed("ui_accept"):
		current_tower = (current_tower + 1) % len(base_towers)
		emit_signal("tower_changed", current_tower)
	move_and_slide()
	var highlight_offset: Vector2 = _get_next_tile(previous_input_direction)
	var highlight_tile: Vector2i = tilemap.local_to_map(Vector2(global_position.x + highlight_offset.x, global_position.y + highlight_offset.y + tile_size / 2))
	emit_signal("select_tile", highlight_tile)

func _input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed() and not moving:
		var tower_name = base_towers[current_tower]
		var cost = gamedata.tower_data[tower_name]["cost"]
		if gold >= cost:
			tower = gamedata.towers_from_string[base_towers[current_tower]].instantiate()
			if not _place_tower(tower):
				tower.queue_free()
				return
			_set_gold(gold - cost)
			tower.reload_time = gamedata.tower_data[tower_name]["reload_time"]
			tower.damage = gamedata.tower_data[tower_name]["damage"]
			tower.bullet_speed = gamedata.tower_data[tower_name]["bullet_speed"]
			tower.pierce = gamedata.tower_data[tower_name]["pierce"]
			tower.range = gamedata.tower_data[tower_name]["range"]
			tower.bullet_lifetime = gamedata.tower_data[tower_name]["bullet_lifetime"]
			get_parent().add_child(tower)

# Make exclusive tile type placements for towers,
# i.e, make some towers have the ability to be placed
# on water, while others not
func _place_tower(tower_to_place) -> bool:
	var place_offset: Vector2 = _get_next_tile(previous_input_direction)
	var next_tile: Vector2i = tilemap.local_to_map(Vector2(global_position.x + place_offset.x, global_position.y + place_offset.y + tile_size / 2))
	var tile_data: TileData = tilemap.get_cell_tile_data(next_tile)

	raycast.target_position = Vector2(place_offset.x, place_offset.y + tile_size / 2)
	raycast.force_raycast_update()

	# Change to placeable
	if not tile_data or not tile_data.get_custom_data("placeable") or raycast.is_colliding():
		return false
	
	tower_to_place.global_position = position + place_offset
	return true

func _move() -> void:
	if moving:
		return

	var move_offset: Vector2 = _get_next_tile(input_direction)
	var next_tile: Vector2i = tilemap.local_to_map(Vector2(global_position.x + move_offset.x, global_position.y + move_offset.y + tile_size / 2))
	var tile_data: TileData = tilemap.get_cell_tile_data(next_tile)

	raycast.target_position = Vector2(move_offset.x, move_offset.y + tile_size / 2)
	raycast.force_raycast_update()

	if not tile_data or not tile_data.get_custom_data("walkable") or raycast.is_colliding():
		return

	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_offset, 0.1)
	tween.connect("finished", func(): moving = false)

func _get_next_tile(direction: Vector2) -> Vector2:
	if direction == Vector2.RIGHT:
		return Vector2(tile_size, tile_size / 2)
	elif direction == Vector2.UP:
		return Vector2(tile_size, -tile_size / 2)
	elif direction == Vector2.LEFT:
		return Vector2(-tile_size, -tile_size / 2)
	elif direction == Vector2.DOWN:
		return Vector2(-tile_size, tile_size / 2)
	else:
		print("Bad direction", direction)
		return Vector2(0, 0)

func _set_gold(new_gold: int) -> void:
	if gold != new_gold:
		gold = new_gold
		emit_signal("gold_changed", gold)

func _set_health(new_health: int) -> void:
	if new_health == 0:
		# TODO: Death screen
		get_tree().quit()
	else:
		health = new_health
		emit_signal("health_changed", health)

# This is connected to `res://enemy/baseenemy.tscn->BaseEnemy` on tree_exiting
# event, via the corresponding .gd script.
func _enemy_dead(take_damage: bool) -> void:
	if take_damage:
		_set_health(health - 1)
	else:
		_set_gold(gold + 20)
