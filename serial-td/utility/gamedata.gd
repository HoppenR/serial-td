extends Node

# Towers need so much more depth than this
var tower_data = {
	"baset0": {
		"damage": 1,
		"rof": 1,
		"range": 200,
	},
	"baset1": {
		"damage": 0,
		"rof": 5,
		"range": 100,
	},
	"baset2": {
		"damage": 3,
		"speed": 0.9,
		"range": 270
	},
}

# Is this a good way to handle rounds?
var round_data = {
	"round_1": {
		"speed": 100,
		"enemies": 5,
		"heat": 1,
	}
}
