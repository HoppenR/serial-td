extends Path2D

var timer

# Send next wave when everything is dead
# (Implement)
var enemiesAlive = []
var enemiesToSpawn = []
var spawnWave = true
var waitForEnemies = false

var currentWave: int = 1
var heat: int = 1

func _ready() -> void:
	enemiesToSpawn = gamedata.wave_data[currentWave]["enemies"]
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.connect("timeout", _spawn_enemy)
	timer.start(1.0)

func _physics_process(delta: float) -> void:
	if spawnWave:
		spawnWave = false
		timer.start(gamedata.wave_data[currentWave]["spawn_speed"])
	if enemiesToSpawn.is_empty():
		timer.stop()
		waitForEnemies = true
	if enemiesAlive.is_empty() and waitForEnemies:
		currentWave += 1
		if currentWave > 10:
			currentWave = 1
			heat += 1
		print("Current wave: ", currentWave)
		enemiesToSpawn = gamedata.wave_data[currentWave].enemies
		spawnWave = true
		waitForEnemies = false

func _spawn_enemy() -> void:
	if enemiesToSpawn.is_empty():
		return
	var enemyName = enemiesToSpawn.pop_front()
	var enemy = gamedata.enemies_from_string[enemyName].instantiate()
	add_child(enemy)
	enemy.hp = gamedata.enemy_data[enemyName]["hp"] * gamedata.wave_data[currentWave]["hp_multiplier"] * heat
	enemy.speed = gamedata.enemy_data[enemyName]["speed"] * gamedata.wave_data[currentWave]["speed_multiplier"] * heat
	enemiesAlive.append(enemy)
