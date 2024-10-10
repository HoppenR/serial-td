extends Path2D

var timer

# Send next wave when everything is dead
var enemies_alive = []
var enemies_to_spawn = []
var waitForEnemies = false

var current_wave: int = 1
var current_level: int = 1
var heat: float = 1

var waiting = false

signal stage_changed()

func _ready() -> void:
	enemies_to_spawn = gamedata.wave_data[current_wave]["enemies"]
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _spawn_enemy)
	timer.start(5.0)

func _physics_process(delta: float) -> void:
	if enemies_alive.is_empty() and enemies_to_spawn.is_empty() and not waiting:
		current_wave += 1
		if current_wave > 10:
			heat += 0.2
			current_wave = 0
			current_level += 1
			emit_signal("stage_changed")
			timer.stop()
			waiting = true
			return
		print("Current wave: ", current_wave)
		print("Heat: ", heat)
		enemies_to_spawn = gamedata.wave_data[current_wave].enemies.duplicate()
		timer.start(5.0)


func _spawn_enemy() -> void:
	if enemies_to_spawn.is_empty():
		timer.stop()
		return
	var enemy_info = enemies_to_spawn.pop_front()
	var enemy_var = enemy_info[0]
	var enemy = gamedata.enemy_data[enemy_var]["node"].instantiate()
	enemy.hp = gamedata.enemy_data[enemy_var]["hp"] * heat
	enemy.speed = gamedata.enemy_data[enemy_var]["speed"] * heat
	if enemy.speed > 550:
		enemy.speed = 550
	add_child(enemy)
	enemies_alive.append(enemy)
	timer.start(enemy_info[1])

func _next_stage():
	waiting = false
	get_tree().change_scene_to_file("res://level" + str(current_level) + ".tscn")
