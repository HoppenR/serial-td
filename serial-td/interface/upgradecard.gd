extends Control

var rng

var upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	var randomUpgrade = rng.randf_range(0, gamedata.upgrades.size())
	upgrade = gamedata.upgrades[randomUpgrade][0]
	$TextureRect.texture = gamedata.upgrades[randomUpgrade][1]
	$Label.text = gamedata.upgrades[randomUpgrade][2]
	$ColorRect.color = Color.BLACK

func _select() -> void:
	$ColorRect.color = Color.ANTIQUE_WHITE

func _deselect() -> void:
	$ColorRect.color = Color.BLACK

func _pick() -> void:
	var buff = upgrade.instantiate()
	add_child(buff)
	
