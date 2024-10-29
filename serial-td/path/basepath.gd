extends Path2D

var timer

@onready var world = get_tree().root.get_node("World")

# Send next wave when everything is dead
var enemies_alive = []
var enemies_to_spawn = []
var waitForEnemies = false
var debug = true

var current_wave: int = 1
var is_bosslevel = false # Set externally

var is_active = true

func _ready() -> void:
	enemies_to_spawn = gamedata.wave_data[current_wave]["enemies"]
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", _spawn_enemy)
	timer.start(10.0)
	# Show path
	var line = Line2D.new()
	line.default_color = Color.AQUAMARINE
	line.points = curve.get_baked_points()
	line.width = 0.5
	add_child(line)
	var line_timer = Timer.new()
	add_child(line_timer)
	line_timer.one_shot = true
	line_timer.timeout.connect(func():
		line.queue_free()
	)
	line_timer.start(7.5)

var wavemax = 10
func _input(event):
	if Input.is_action_just_pressed("debug_skip"):
		if wavemax == 10:
			wavemax = 1
		else:
			wavemax = 10

# Probably inefficient to check every frame?
# Can use enemy dying event instead of _physics_process,
# won't need `is_active` then, either
func _physics_process(delta: float) -> void:
	if not is_active:
		return
	# Check for next wave continuously…
	if enemies_alive.is_empty() and enemies_to_spawn.is_empty():
		current_wave += 1
		if current_wave == 11 and is_bosslevel:
			enemies_to_spawn = gamedata.wave_data["boss"].enemies.duplicate()
		elif current_wave > wavemax:
			timer.stop()
			is_active = false
			world.emit_signal("stage_changed")
			current_wave = 1
			return
		else:
			enemies_to_spawn = gamedata.wave_data[current_wave].enemies.duplicate()
		timer.start(4.0)

func _spawn_enemy() -> void:
	if enemies_to_spawn.is_empty():
		timer.stop()
		return
	var enemy_info = enemies_to_spawn.pop_front()
	var enemy_var = enemy_info[0]
	var enemy = gamedata.enemy_data[enemy_var]["node"].instantiate()
	enemy.z_index = 1
	enemy.hp = gamedata.enemy_data[enemy_var]["hp"] * Global.heat
	enemy.speed = gamedata.enemy_data[enemy_var]["speed"] * Global.heat
	enemy.immunity = gamedata.enemy_data[enemy_var]["immunity"]
	enemy.value = gamedata.enemy_data[enemy_var]["value"]
	if enemy.speed > 550:
		enemy.speed = 550
	add_child(enemy)
	enemies_alive.append(enemy)
	timer.start(enemy_info[1])
