extends Path2D

var timer

# Send next wave when everything is dead
# (Implement)
var enemies_alive = []
var enemies_to_spawn = []
var waitForEnemies = false

var current_wave: int = 1
var heat: float = 1

func _ready() -> void:
	enemies_to_spawn = gamedata.wave_data[current_wave]["enemies"]
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.connect("timeout", _spawn_enemy)
	timer.start(5.0)

func _physics_process(delta: float) -> void:
	if enemies_alive.is_empty() and enemies_to_spawn.is_empty():
		current_wave += 1
		if current_wave > 10:
			current_wave = 1
			heat += 0.1
		print("Current wave: ", current_wave)
		print("Heat: ", heat)
		enemies_to_spawn = gamedata.wave_data[current_wave].enemies.duplicate()
		timer.start(gamedata.wave_data[current_wave]["spawn_speed"] / heat)

func _spawn_enemy() -> void:
	if enemies_to_spawn.is_empty():
		timer.stop()
		return
	var enemyName = enemies_to_spawn.pop_front()
	var enemy = gamedata.enemies_from_string[enemyName].instantiate()
	enemy.hp = gamedata.enemy_data[enemyName]["hp"] * heat
	enemy.speed = gamedata.enemy_data[enemyName]["speed"] * gamedata.wave_data[current_wave]["speed_multiplier"] * heat
	if enemy.speed > 550:
		enemy.speed = 550
	add_child(enemy)
	enemies_alive.append(enemy)
