extends Path2D

var enemyPreload = preload("res://enemy/baseenemy.tscn")

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.connect("timeout", _spawn_enemy)
	timer.start(1.0)

func _spawn_enemy() -> void:
	var enemy = enemyPreload.instantiate()
	add_child(enemy)
