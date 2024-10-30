extends Node

var current_tower: int = 0
var heat: float = 1.0

signal health_changed(new_health: int)
var health: int = 100:
	set(new_value):
		if new_value < 1:
			# TODO: Death screen
			get_tree().quit()
		else:
			health = new_value
			emit_signal("health_changed", health)

signal gold_changed(new_gold: int)
var gold: int = 2000:
	set(new_value):
		if gold != new_value:
			gold = new_value
			emit_signal("gold_changed", gold)
