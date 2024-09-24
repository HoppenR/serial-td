extends Path2D

var enemyPreload = preload("res://enemy/baseenemy.tscn")
var spawnWave = true
var waitForEnemies = false

# Send next wave when everything is dead
# (Implement)
var enemiesAlive = []

var currentWave: int = 1
var spawnedThisWave: int = 0
var timer

func _physics_process(delta: float) -> void:
	if spawnWave:
		spawnWave = false
		timer = Timer.new()
		add_child(timer)
		timer.one_shot = false
		timer.connect("timeout", _spawn_enemy)
		timer.start(3.0 / float(currentWave))
	if spawnedThisWave >= currentWave:
		timer.stop()
		waitForEnemies = true
	if enemiesAlive.is_empty() and waitForEnemies:
		spawnedThisWave = 0
		currentWave += 1
		print("Current wave: ", currentWave)
		spawnWave = true
		waitForEnemies = false

func _spawn_enemy() -> void:
	var enemy = enemyPreload.instantiate()
	add_child(enemy)
	enemy.hp = 10 + currentWave * 5
	enemy.speed = 100 + currentWave * 2
	enemiesAlive.append(enemy)
	spawnedThisWave += 1
