extends Node

func _react_to_element(this, target, internal_element, external_element) -> bool:
	if not internal_element:
		return false

	match internal_element:
			gamedata.damage_type.ELECTRICITY:
				match external_element:
					gamedata.damage_type.ICE:
						target._remove_element(external_element)
						var effect = gamedata.electric_ice.instantiate()
						target._add_effect(effect)
						this._remove_effect()
						return false
					gamedata.damage_type.WATER:
						target._remove_element(external_element)
						this._remove_effect()
						var effect = gamedata.electric_wet.instantiate()
						target._add_effect(effect)
						return false
			gamedata.damage_type.WATER:
				match external_element:
					gamedata.damage_type.FIRE:
						target._remove_element(external_element)
						return false
					gamedata.damage_type.ELECTRICITY:
						target._remove_element(external_element)
						var effect = gamedata.electric_wet.instantiate()
						target._add_effect(effect)
						this._remove_effect()
					gamedata.damage_type.ICE:
						this._remove_effect()
						return false
			gamedata.damage_type.ICE:
				match external_element:
					gamedata.damage_type.FIRE:
						this._remove_effect()
						return true
					gamedata.damage_type.ELECTRICITY:
						target._remove_element(external_element)
						this._remove_effect()
						var effect = gamedata.electric_ice.instantiate()
						target._add_effect(effect)
						return true
			gamedata.damage_type.FIRE:
				match external_element:
					gamedata.damage_type.ICE:
						target._remove_element(external_element)
						return false
					gamedata.damage_type.WATER:
						this._remove_effect()
						return true
			gamedata.damage_type.GRASS:
				match external_element:
					gamedata.damage_type.ICE:
						this._remove_effect()
						return true
					gamedata.damage_type.FIRE:
						this._remove_effect()
						return true
					gamedata.damage_type.ELECTRICITY:
						target._remove_element(external_element)
						return false
					gamedata.damage_type.WATER:
						Global.health += 1
						target._remove_element(external_element)
						return false
	return true	

func _init_effect(this) -> void:
	var damage_interval = gamedata.damage_data[this.main_element]["damage_frequency"]
	var duration = gamedata.damage_data[this.main_element]["duration"]
	this.damage = gamedata.damage_data[this.main_element]["damage"]
	this.slow = gamedata.damage_data[this.main_element]["speed_debuff"]

	if this.secondary_element:
		this.damage += gamedata.damage_data[this.secondary_element]["damage"] / 2
		this.slow *= gamedata.damage_data[this.secondary_element]["speed_debuff"]
		duration += gamedata.damage_data[this.secondary_element]["duration"] / 2
		damage_interval = min(gamedata.damage_data[this.secondary_element]["damage_frequency"], damage_interval)

	this.get_parent().speed *= this.slow
	var timer = Timer.new()
	timer.one_shot = false
	timer.connect("timeout", this._deal_damage)
	this.add_child(timer)
	timer.start(damage_interval)
	this.life_timer = Timer.new()
	this.life_timer.one_shot = true
	this.life_timer.connect("timeout", this._remove_effect)
	this.add_child(this.life_timer)
	this.life_timer.start(duration)
