class_name Attack

var attackDamage: float
var attackMultiplier: float
var knockbackForce: float
var attackPosition: Vector2


func get_multiplier(tool, type):
	var multiplier: float
	match tool:
		global.Tools.None:
			match type:
				global.Types.Player:
					multiplier = 1
		global.Tools.Axe:
			match type:
				global.Types.Enemy:
					multiplier = 0.5
				global.Types.Choppable:
					multiplier = 1.0
				global.Types.Mineable:
					multiplier = 0.1
		global.Tools.Pickaxe:
			match type:
				global.Types.Enemy:
					multiplier = 0.5
				global.Types.Choppable:
					multiplier = 0.1
				global.Types.Mineable:
					multiplier = 1.0
		global.Tools.Sword:
			match type:
				global.Types.Enemy:
					multiplier = 1
				global.Types.Choppable:
					multiplier = 0.2
				global.Types.Mineable:
					multiplier = 0.1
	return multiplier
