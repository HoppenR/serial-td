extends Node

#Effects
var electricfield = preload("res://effects/electricfield.tscn")
var fire = preload("res://effects/fire.tscn")
var frozen = preload("res://effects/frozen.tscn")
var wet = preload("res://effects/wet.tscn")
var electric_wet = preload("res://effects/wetelectric.tscn")
var electric_ice = preload("res://effects/iceelectric.tscn")

enum damage_type {
	STANDARD,
	FIRE,
	ICE,
	ELECTRICITY,
	WATER,
}

var damage_data = {
	damage_type.FIRE:  {
		"damage": 2,
		"damage_frequency": 0.25,
		"duration": 1.0, 
		"range": 0, 
		"speed_debuff": 1,
	},
	damage_type.ICE:  {
		"damage": 0,
		"damage_frequency": 2,
		"duration": 5.0, 
		"range": 0, 
		"speed_debuff": 0.25,
	},
	damage_type.ELECTRICITY:  {
		"damage": 1,
		"damage_frequency": 0.25,
		"duration": 5.0, 
		"range": 25, 
		"speed_debuff": 0.8,
	},
	damage_type.WATER:  {
		"damage": 0,
		"damage_frequency": 0.25,
		"duration": 5.0, 
		"range": 0, 
		"speed_debuff": 1,
	},
}

var upgrades = [
	[preload("res://upgrades/firebuffs/firedamagebuff.tscn"), 
	 preload("res://assets/effects/fireeffect.png"),
	 "Increases Fire damage"],
	[preload("res://upgrades/firebuffs/firefrequencybuff.tscn"), 
	 preload("res://assets/effects/fireeffect.png"),
	 "Increases Fire damage Frequency"],
	[preload("res://upgrades/firebuffs/firedurationbuff.tscn"), 
	 preload("res://assets/effects/fireeffect.png"),
	 "Increases Fire duration"],
	[preload("res://upgrades/electricbuffs/electricdamagebuff.tscn"), 
	 preload("res://assets/effects/electriceffect.png"),
	 "Increases Electric damage"],
	[preload("res://upgrades/electricbuffs/electricfrequencybuff.tscn"), 
	 preload("res://assets/effects/electriceffect.png"),
	 "Increases Electric damage Frequency"],
	[preload("res://upgrades/electricbuffs/electricdurationbuff.tscn"), 
	 preload("res://assets/effects/electriceffect.png"),
	 "Increases Electric duration"],
	[preload("res://upgrades/electricbuffs/electricslowbuff.tscn"), 
	 preload("res://assets/effects/electriceffect.png"),
	 "Increases the slow effect of Electric"],
	[preload("res://upgrades/icebuffs/icedamagebuff.tscn"), 
	 preload("res://assets/effects/frozeneffect.png"),
	 "Increases the damge of Ice"],
	[preload("res://upgrades/towerbuffs/icetowerreloadbuff.tscn"), 
	 preload("res://assets/towers/icet0.png"),
	 "Reduces reload time of Ice"],
	[preload("res://upgrades/general/heatdebuff.tscn"), 
	 preload("res://assets/upgrade_icons/decrease.png"),
	 "Reduces Heat"],
	[preload("res://upgrades/general/healthbuff.tscn"), 
	 preload("res://assets/interface_icons/life_heart.png"),
	 "Gain 40 Health"],
]

enum towers {
	BASE_T0,
	BASE_T1,
	ICE_T0,
	FLAME_T0,
	ELECTRIC_T0,
	WATER_T0,
}

var tower_data = {
	towers.BASE_T0: {
		"node": preload("res://towers/base/baset0.tscn"),
		"texture": preload("res://assets/towers/gun.png"),
		"damage": 6,
		"cost": 100,
		"range": 10,
		"pierce": 2,
		"reload_time": 0.3,
		"bullet_speed": 15,
		"bullet_lifetime": 0.5,
	},
	towers.BASE_T1: {
		"node": preload("res://towers/base/baset1.tscn"),
		"texture": preload("res://assets/towers/gun2.png"),
		"damage": 14,
		"cost": 200,
		"range": 15,
		"pierce": 2,
		"reload_time": 0.2,
		"bullet_speed": 25,
		"bullet_lifetime": 0.8,
	},
	towers.FLAME_T0: {
		"node": preload("res://towers/flame/flamet0.tscn"),
		"texture": preload("res://assets/towers/flamet0.png"),
		"damage": 1,
		"cost": 300,
		"range": 10,
		"pierce": 10,
		"reload_time": 0.01,
		"bullet_speed": 15,
		"bullet_lifetime": 0.2,
	},
	towers.ICE_T0: {
		"node": preload("res://towers/ice/icet0.tscn"),
		"texture": preload("res://assets/towers/icet0.png"),
		"damage": 2,
		"cost": 60,
		"range": 50,
		"pierce": 10,
		"reload_time": 1.25,
		"bullet_speed": 40,
		"bullet_lifetime": 0.5,
	},
	towers.ELECTRIC_T0: {
		"node": preload("res://towers/electric/electrict0.tscn"),
		"texture": preload("res://assets/towers/electrict0.png"),
		"damage": 1,
		"cost": 250,
		"range": 10,
		"pierce": 3,
		"reload_time": 1.5,
		"bullet_speed": 15,
		"bullet_lifetime": 1.0,
	},
	towers.WATER_T0: {
		"node": preload("res://towers/water/watert0.tscn"),
		"texture": preload("res://assets/towers/watert0.png"),
		"damage": 1,
		"cost": 150,
		"range": 15,
		"pierce": 6,
		"reload_time": 0.01,
		"bullet_speed": 15,
		"bullet_lifetime": 0.4,
	},
}

enum enemies {
	SAW1,
	SAW2,
	SAW3,
	SAW4,
}


var enemy_data = {
	enemies.SAW1: {
		"node": preload("res://enemy/saw/saw1.tscn"),
		"hp": 20,
		"speed": 100,
		"value": 10,
	},
	enemies.SAW2: {
		"node": preload("res://enemy/saw/saw2.tscn"),
		"hp": 10,
		"speed": 300,
		"value": 30,
	},
	enemies.SAW3: {
		"node": preload("res://enemy/saw/saw3.tscn"),
		"hp": 30,
		"speed": 200,
		"value": 50,
	},
	enemies.SAW4: {
		"node": preload("res://enemy/saw/saw4.tscn"),
		"hp": 62,
		"speed": 150,
		"value": 100,
	},
}

var wave_data = {
	1: {
		"enemies": [ 
					 [enemies.SAW1, 10]
				   ],
	},
	2: {
		"enemies": [ 
					 [enemies.SAW1, 0.5], 
					 [enemies.SAW1, 0.5],
					 [enemies.SAW1, 0.5],
					 [enemies.SAW1, 0.5],
					 [enemies.SAW1, 0.5],
				   ],
	},
	3: {
		"enemies": [ 
					 [enemies.SAW1, 0.3],
					 [enemies.SAW1, 0.3], 
					 [enemies.SAW1, 0.3],
					 [enemies.SAW3, 0.3],
					 [enemies.SAW1, 0.3],
					 [enemies.SAW1, 0.3],
					 [enemies.SAW1, 0.3],
				   ],
	},
	4: {
		"enemies": [ 
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.5],
					 [enemies.SAW3, 0.5],
					 [enemies.SAW3, 0.2],
				   ],
	},
	5: {
		"enemies": [ 
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.2],
					 [enemies.SAW3, 0.2],
				   ],
	},
	6: {
		"enemies": [ 
					 [enemies.SAW2, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW2, 0.5],
				   ],
	},

	7: {
		"enemies": [ 
					 [enemies.SAW1, 0.5],
					 [enemies.SAW1, 0.5],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW1, 0.5],
					 [enemies.SAW1, 0.5],
				   ],
	},

	8: {
		"enemies": [ 
					 [enemies.SAW3, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW2, 0.5],
					 [enemies.SAW3, 0.5],
				   ],
	},
	9: {
		"enemies": [ 
					 [enemies.SAW4, 0.5],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW4, 0.5],
				   ],
	},
	10: {
		"enemies": [ 
					 [enemies.SAW2, 0.1],
					 [enemies.SAW2, 0.1],
					 [enemies.SAW2, 0.1],
					 [enemies.SAW2, 0.1],
					 [enemies.SAW2, 0.1],
					 [enemies.SAW2, 0.1],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW4, 0.5],
					 [enemies.SAW4, 0.5],
				   ],
	},
}
