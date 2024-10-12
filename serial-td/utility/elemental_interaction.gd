extends Node

func _react_to_element(this, target, internal_element, external_element) -> void:
	if not internal_element:
		return

	match internal_element:
			gamedata.damage_type.ELECTRICITY:
				match external_element:
					gamedata.damage_type.ICE:
						target._remove_element(external_element)
						var effect = gamedata.electric_ice.instantiate()
						target._add_effect(effect)
						this._remove_effect()
					gamedata.damage_type.WATER:
						target._remove_element(external_element)
						var effect = gamedata.electric_wet.instantiate()
						target._add_effect(effect)
						this._remove_effect()
			gamedata.damage_type.WATER:
				match external_element:
					gamedata.damage_type.FIRE:
						target._remove_element(external_element)
					gamedata.damage_type.ELECTRICITY:
						target._remove_element(external_element)
						var effect = gamedata.electric_wet.instantiate()
						target._add_effect(effect)
						this._remove_effect()
					gamedata.damage_type.ICE:
						this._remove_effect()
			gamedata.damage_type.ICE:
				match external_element:
					gamedata.damage_type.FIRE:
						this._remove_effect()
					gamedata.damage_type.ELECTRICITY:
						target._remove_element(external_element)
						var effect = gamedata.electric_ice.instantiate()
						target._add_effect(effect)
						this._remove_effect()
			gamedata.damage_type.FIRE:
				match external_element:
					gamedata.damage_type.ICE:
						target._remove_element(external_element)
					gamedata.damage_type.WATER:
						this._remove_effect()
