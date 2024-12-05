extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_objects(20, 15)

func spawn_objects(trees: int, slimes: int):
	var treeFile = preload("res://Scenes/tree.tscn")
	var slimeFile = preload("res://Scenes/Characters/slime.tscn")


	for tree in range(1, trees):
		var treeInst = treeFile.instantiate()
		var treeX: int = randi_range(0, 765)
		var treeY: int = randi_range(0, 800)
		treeInst.global_position.x = treeX
		treeInst.global_position.y = treeY
		treeInst.z_index = 1
		get_parent().add_child.call_deferred(treeInst)
		
	for slime in range(1, slimes):
		var slimeInst = slimeFile.instantiate()
		var slimeX: int = randi_range(0, 765)
		var slimeY: int = randi_range(0, 800)
		slimeInst.global_position.x = slimeX
		slimeInst.global_position.y = slimeY
		slimeInst.z_index = 1
		get_parent().add_child.call_deferred(slimeInst)
