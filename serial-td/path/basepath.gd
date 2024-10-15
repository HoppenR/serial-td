extends Path2D

var timer

@onready var world = get_tree().root.get_node("World")

# Send next wave when everything is dead
var enemies_alive = []
var enemies_to_spawn = []
var waitForEnemies = false

var current_wave: int = 1

var is_active = true

func _ready() -> void:
	enemies_to_spawn = gamedata.wave_data[current_wave]["enemies"]
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _spawn_enemy)
	timer.start(10.0)

# Probably inefficient to check every frame?
# Can use enemy dying event instead of _physics_process,
# won't need `is_active` then, either
func _physics_process(delta: float) -> void:
	if not is_active:
		return
	# Check for next wave continuously…
	if enemies_alive.is_empty() and enemies_to_spawn.is_empty():
		current_wave += 1
		if current_wave > 10:
			timer.stop()
			is_active = false
			world.emit_signal("stage_changed")
			current_wave = 1
			return
		enemies_to_spawn = gamedata.wave_data[current_wave].enemies.duplicate()
		timer.start(5.0)

func _spawn_enemy() -> void:
	if enemies_to_spawn.is_empty():
		timer.stop()
		return
	var enemyInfo = enemies_to_spawn.pop_front()
	var enemyName = enemyInfo[0]
	var enemy = gamedata.enemies_from_string[enemyName].instantiate()
	enemy.z_index = 1
	enemy.hp = gamedata.enemy_data[enemy_var]["hp"] * Global.heat
	enemy.speed = gamedata.enemy_data[enemy_var]["speed"] * Global.heat
	enemy.immunity = gamedata.enemy_data[enemy_var]["immunity"]
	if enemy.speed > 550:
		enemy.speed = 550
	add_child(enemy)
	enemies_alive.append(enemy)
	timer.start(enemyInfo[1])
