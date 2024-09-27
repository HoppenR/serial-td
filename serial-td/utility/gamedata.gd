extends Node

#Enemies
var saw1 = preload("res://enemy/saw/saw1.tscn")
var saw2 = preload("res://enemy/saw/saw2.tscn")
var saw3 = preload("res://enemy/saw/saw3.tscn")
var saw4 = preload("res://enemy/saw/saw4.tscn")

#Towers
var baset0 = preload("res://towers/base/baset0.tscn")
var baset1 = preload("res://towers/base/baset1.tscn")

var enemies_from_string = {
	"saw1": saw1,
	"saw2": saw2,
	"saw3": saw3,
	"saw4": saw4,
}

var towers_from_string = {
	"baset1": baset0,
	"baset0": baset1,
}

# Towers need so much more depth than this
var tower_data = {
	"baset0": {
		"damage": 3,
		"cost": 100,
		"range": 200,
		"reload_time": 0.3,
		"bullet_speed": 10,
	},
	"baset1": {
		"damage": 7,
		"cost": 200,
		"range": 100,
		"reload_time": 0.2,
		"bullet_speed": 20,
	},
	"baset2": {
		"damage": 14,
		"cost": 350,
		"range": 270,
		"reload_time": 0.1,
		"bullet_speed": 40,
	},
}

var enemy_data = {
	"saw1": {
		"hp": 10,
		"speed": 100,
	},
	"saw2": {
		"hp": 5,
		"speed": 300,
	},
	"saw3": {
		"hp": 15,
		"speed": 200,
	},
	"saw4": {
		"hp": 31,
		"speed": 150,
	},
}

var wave_data = {
	1: {
		"enemies": ["saw1"],
		"hp_multiplier": 1,
		"speed_multiplier": 1,
		"spawn_speed": 3,
	},
	2: {
		"enemies": ["saw1", "saw1"],
		"hp_multiplier": 1.2,
		"speed_multiplier": 1.4,
		"spawn_speed": 1,
	},
	3: {
		"enemies": ["saw1", "saw1", "saw1"],
		"hp_multiplier": 1.4,
		"speed_multiplier": 1.4,
		"spawn_speed": 1,
	},
	4: {
		"enemies": ["saw1", "saw1", "saw1", "saw1"],
		"hp_multiplier": 2,
		"speed_multiplier": 1.5,
		"spawn_speed": 2,
	},
	5: {
		"enemies": ["saw1", "saw1", "saw2", "saw2", "saw1"],
		"hp_multiplier": 1,
		"speed_multiplier": 1,
		"spawn_speed": 1.5,
	},
	6: {
		"enemies": ["saw1", "saw1", "saw1", "saw1", "saw1", "saw1", "saw1", "saw1", "saw1",],
		"hp_multiplier": 1,
		"speed_multiplier": 1,
		"spawn_speed": 0.2,
	},
	7: {
		"enemies": ["saw3"],
		"hp_multiplier": 1,
		"speed_multiplier": 0.4,
		"spawn_speed": 2,
	},
	8: {
		"enemies": ["saw2", "saw2", "saw2", "saw2", "saw2", "saw2", "saw2", "saw2", "saw2"],
		"hp_multiplier": 0.8,
		"speed_multiplier": 1,
		"spawn_speed": 0.2,
	},
	9: {
		"enemies": ["saw1", "saw1", "saw3", "saw1", "saw1"],
		"hp_multiplier": 1,
		"speed_multiplier": 0.6,
		"spawn_speed": 0.1,
	},
	10: {
		"enemies": ["saw3", "saw2", "saw3", "saw2", "saw3"],
		"hp_multiplier": 1.2,
		"speed_multiplier": 1,
		"spawn_speed": 1,
	}
}
