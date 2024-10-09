extends Node

#Enemies
var saw1 = preload("res://enemy/saw/saw1.tscn")
var saw2 = preload("res://enemy/saw/saw2.tscn")
var saw3 = preload("res://enemy/saw/saw3.tscn")
var saw4 = preload("res://enemy/saw/saw4.tscn")

#Towers
var baset0 = preload("res://towers/base/baset0.tscn")
var baset1 = preload("res://towers/base/baset1.tscn")

var firet0 = preload("res://towers/flame/flamet0.tscn")

var icet0 = preload("res://towers/ice/icet0.tscn")

var electrict0 = preload("res://towers/electric/electrict0.tscn")

#Effects
var electricfield = preload("res://effects/electricfield.tscn")
var fire = preload("res://effects/fire.tscn")
var frozen = preload("res://effects/frozen.tscn")

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
		"damage_frequency": 1,
		"duration": 10.0, 
		"range": 0, 
		"speed_debuff": 0.25,
	},
	damage_type.ELECTRICITY:  {
		"damage": 1,
		"damage_frequency": 0.5,
		"duration": 100.0, 
		"range": 25, 
		"speed_debuff": 0.9,
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
]

var enemies_from_string = {
	"saw1": saw1,
	"saw2": saw2,
	"saw3": saw3,
	"saw4": saw4,
}

var towers_from_string = {
	"baset0": baset0,
	"baset1": baset1,
	"firet0": firet0,
	"icet0": icet0,
	"electrict0": electrict0,
}

# Towers need so much more depth than this
var tower_data = {
	"baset0": {
		"damage": 6,
		"cost": 100,
		"range": 10,
		"pierce": 1,
		"reload_time": 0.3,
		"bullet_speed": 15,
		"bullet_lifetime": 0.5,
	},
	"baset1": {
		"damage": 14,
		"cost": 200,
		"range": 15,
		"pierce": 2,
		"reload_time": 0.2,
		"bullet_speed": 25,
		"bullet_lifetime": 0.8,
	},
	"baset2": {
		"damage": 28,
		"cost": 350,
		"range": 23,
		"pierce": 3,
		"reload_time": 0.1,
		"bullet_speed": 30,
		"bullet_lifetime": 1.0,
	},
	"firet0": {
		"damage": 1,
		"cost": 300,
		"range": 10,
		"pierce": 10,
		"reload_time": 0.01,
		"bullet_speed": 15,
		"bullet_lifetime": 2.0,
	},
	"icet0": {
		"damage": 29,
		"cost": 800,
		"range": 50,
		"pierce": 10,
		"reload_time": 2.25,
		"bullet_speed": 40,
		"bullet_lifetime": 1.0,
	},
	"electrict0": {
		"damage": 3,
		"cost": 100,
		"range": 10,
		"pierce": 1,
		"reload_time": 1.5,
		"bullet_speed": 15,
		"bullet_lifetime": 5.0,
	},
}

var enemy_data = {
	"saw1": {
		"hp": 20,
		"speed": 100,
		"value": 10,
	},
	"saw2": {
		"hp": 10,
		"speed": 300,
		"value": 30,
	},
	"saw3": {
		"hp": 30,
		"speed": 200,
		"value": 50,
	},
	"saw4": {
		"hp": 62,
		"speed": 150,
		"value": 100,
	},
}

var wave_data = {
	1: {
		"enemies": [ 
					 ["saw1", 10]
				   ],
	},
	2: {
		"enemies": [ 
					 ["saw1", 0.5], 
					 ["saw1", 0.5],
					 ["saw1", 0.5],
					 ["saw1", 0.5],
					 ["saw1", 0.5],
				   ],
	},
	3: {
		"enemies": [ 
					 ["saw1", 0.3],
					 ["saw1", 0.3], 
					 ["saw1", 0.3],
					 ["saw3", 0.3],
					 ["saw1", 0.3],
					 ["saw1", 0.3],
					 ["saw1", 0.3],
				   ],
	},
	4: {
		"enemies": [ 
					 ["saw3", 0.5],
					 ["saw3", 0.2],
					 ["saw3", 0.5],
					 ["saw3", 0.2],
				   ],
	},
	5: {
		"enemies": [ 
					 ["saw3", 0.2],
					 ["saw3", 0.2],
					 ["saw3", 0.2],
					 ["saw3", 0.2],
					 ["saw3", 0.2],
					 ["saw3", 0.2],
				   ],
	},
	6: {
		"enemies": [ 
					 ["saw2", 0.5],
					 ["saw2", 0.5],
					 ["saw2", 0.5],
					 ["saw2", 0.5],
					 ["saw2", 0.5],
					 ["saw2", 0.5],
				   ],
	},

	7: {
		"enemies": [ 
					 ["saw1", 0.5],
					 ["saw1", 0.5],
					 ["saw4", 0.5],
					 ["saw1", 0.5],
					 ["saw1", 0.5],
				   ],
	},

	8: {
		"enemies": [ 
					 ["saw3", 0.5],
					 ["saw2", 0.5],
					 ["saw4", 0.5],
					 ["saw2", 0.5],
					 ["saw3", 0.5],
				   ],
	},
	9: {
		"enemies": [ 
					 ["saw4", 0.5],
					 ["saw4", 0.5],
					 ["saw4", 0.5],
				   ],
	},
	10: {
		"enemies": [ 
					 ["saw2", 0.1],
					 ["saw2", 0.1],
					 ["saw2", 0.1],
					 ["saw2", 0.1],
					 ["saw2", 0.1],
					 ["saw2", 0.1],
					 ["saw4", 0.5],
					 ["saw4", 0.5],
					 ["saw4", 0.5],
					 ["saw4", 0.5],
				   ],
	},
}
