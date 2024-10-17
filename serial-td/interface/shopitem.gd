extends Control

var upgrade

func _select() -> void:
	$ColorRect.color = Color.DARK_SALMON

func _deselect() -> void:
	$ColorRect.color = Color.BLACK

func _pick() -> void:
	var buff = upgrade.instantiate()
	add_child(buff)
