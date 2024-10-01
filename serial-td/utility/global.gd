extends Node

signal gold_changed(new_gold: int)
signal health_changed(new_health: int)
var gold: int = 500
var health: int = 100
var current_tower: int = 0

func set_health(new_health: int) -> void:
	if new_health < 1:
		# TODO: Death screen
		get_tree().quit()
	else:
		health = new_health
		emit_signal("health_changed", health)

func set_gold(new_gold: int) -> void:
	if gold != new_gold:
		gold = new_gold
		emit_signal("gold_changed", gold)
