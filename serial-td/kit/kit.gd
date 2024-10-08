extends CharacterBody2D

var base_towers = [
	"baset0",
	"baset1",
	"firet0",
	"icet0",
	"electrict0",
]

var upgrade_interface = preload("res://interface/upgradeselection.tscn")

@onready var tilemap: TileMapLayer = $"../PlayerTraversal"

var raycast

var current_tower: int = 0

# NOTE: `res://interface/ui_control.gd`
signal tower_changed(new_tower: int)
# NOTE: `res://path/tilemap.gd`
signal select_tile(position: Vector2)

var input_direction: Vector2 = Vector2.UP
var previous_input_direction: Vector2 = Vector2.UP

var moving: bool = false
var tile_size: int = 16
var tower_placement_range: int = 32
var tower

func _ready() -> void:
	var path_node = get_tree().get_root().get_node("World/EnemyPath")
	path_node.connect("stage_changed", _stage_changed)
	raycast = $Raycast

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		input_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		input_direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_left"):
		input_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		input_direction = Vector2.RIGHT
	
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
		previous_input_direction = input_direction;
		if not Input.is_action_pressed("ui_control"):
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
		if Global.gold >= cost:
			tower = gamedata.towers_from_string[base_towers[current_tower]].instantiate()
			if not _place_tower(tower):
				tower.queue_free()
				return
			Global.set_gold(Global.gold - cost)
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

# This is connected to `res://enemy/baseenemy.tscn->BaseEnemy` on tree_exiting
# event, via the corresponding .gd script.
func _enemy_dead(take_damage: bool, enemy_hp: int) -> void:
	if take_damage:
		Global.set_health(Global.health - enemy_hp)
	else:
		Global.set_gold(Global.gold + 20)

func _stage_changed() -> void:
	var next_upgrade = upgrade_interface.instantiate()
	add_child(next_upgrade);

func _upgrade_applied() -> void:
	var path_node = get_tree().get_root().get_node("World/EnemyPath")
	path_node._next_stage()
