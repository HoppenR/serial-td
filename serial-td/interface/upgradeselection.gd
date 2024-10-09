extends CanvasLayer

var card = preload("res://interface/upgradecard.tscn")
var cards = []

var selectedIndex: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		var current_card = card.instantiate()
		current_card.global_position = Vector2(get_viewport().size.x / 2, (get_viewport().size.y / 2) + i * 50)
		cards.append(current_card)
		add_child(current_card)
	cards[selectedIndex]._select()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		cards[selectedIndex]._deselect()
		selectedIndex -= 1;
		if selectedIndex < 0:
			selectedIndex += 1
		cards[selectedIndex]._select()
	elif Input.is_action_just_pressed("ui_down"):
		cards[selectedIndex]._deselect()
		selectedIndex += 1;
		if selectedIndex > (cards.size() - 1):
			selectedIndex -= 1
		cards[selectedIndex]._select()

	if Input.is_action_just_pressed("ui_accept"):
		cards[selectedIndex]._pick()
		get_parent()._upgrade_applied()
		queue_free()
