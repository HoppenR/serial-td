extends Area2D

var damage: int

var projectileload

var enemy_array = []

func _ready() -> void:
	$RangeCollision.shape.radius = 25 
	projectileload = preload("res://projectiles/electricprojectile.tscn")
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", _deal_damage)
	add_child(timer)
	timer.start(1.0)

func _deal_damage() -> void:
	for i in range(enemy_array.size()):
		enemy_array[i].take_damage(damage, gamedata.damage_type.ELECTRICITY)


func _on_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())

func _on_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
