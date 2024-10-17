extends CanvasLayer

var card = preload("res://interface/upgradecard.tscn")
var cards = []

var shop_item = preload("res://interface/shopitem.tscn")
var viewing_shop: bool = false
var shop = []
var shop_items = [
	gamedata.towers.BASE_T1,
	gamedata.towers.FLAME_T1,
	gamedata.towers.ELECTRIC_T1,
	gamedata.towers.ICE_T1,
	gamedata.towers.WATER_T1,
	gamedata.towers.GRASS_T1,
]


var selectedIndex: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		var current_card = card.instantiate()
		cards.append(current_card)
		add_child(current_card)

	#for i in 5:
	#	var current_item = shop_item.instantiate()
	#	shop.append(current_item)
	#	add_child(current_item)
	#cards[selectedIndex]._select()

func _process(_delta: float) -> void:
	for i in 3:
		cards[i].global_position = Vector2(get_viewport().size.x / 2 + (-200 + i * 200), (get_viewport().size.y / 2))
		
	#for i in 5:
	#	shop[i].global_position = Vector2(get_viewport().size.x / 2 + (-150 + i * 100), (get_viewport().size.y / 2) - 75)
	
	if viewing_shop:
		_view_shop_items()
	else:
		_view_free_upgrades()
	
	##if Input.is_action_just_pressed("ui_up") and not viewing_shop:
	##	cards[selectedIndex]._deselect()
	##	shop[selectedIndex]._select()
	##	viewing_shop = true
	##elif Input.is_action_just_pressed("ui_down") and viewing_shop:
	##	if selectedIndex > (cards.size() - 1):
	##		selectedIndex = (cards.size() - 1)
	##	cards[selectedIndex]._select()
	##	shop[selectedIndex]._deselect()
	##	viewing_shop = false

	if Input.is_action_just_pressed("ui_accept"):
		cards[selectedIndex]._pick()
		#get_parent()._upgrade_applied()
		queue_free()

func _view_free_upgrades() -> void:
	if Input.is_action_just_pressed("ui_left"):
		cards[selectedIndex]._deselect()
		selectedIndex -= 1;
		if selectedIndex < 0:
			selectedIndex += 1
		cards[selectedIndex]._select()
	elif Input.is_action_just_pressed("ui_right"):
		cards[selectedIndex]._deselect()
		selectedIndex += 1;
		if selectedIndex > (cards.size() - 1):
			selectedIndex -= 1
		cards[selectedIndex]._select()
	
func _view_shop_items() -> void:
	if Input.is_action_just_pressed("ui_left"):
		shop[selectedIndex]._deselect()
		selectedIndex -= 1;
		if selectedIndex < 0:
			selectedIndex += 1
		shop[selectedIndex]._select()
	elif Input.is_action_just_pressed("ui_right"):
		shop[selectedIndex]._deselect()
		selectedIndex += 1;
		if selectedIndex > (shop.size() - 1):
			selectedIndex -= 1
		shop[selectedIndex]._select()
