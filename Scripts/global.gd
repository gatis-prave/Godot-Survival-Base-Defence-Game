extends Node2D

var firstLoad = true

var currentScene = "World"

var playerStartX = 395
var playerStartY = 320

var exitCliffsideX = 793
var exitCliffsideY = 304

enum Types {
	Player,
	Enemy,
	Choppable,
	Mineable
}

enum Tools {
	None,
	Sword,
	Axe,
	Pickaxe
}

enum Items {
	None
}
