extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.firstLoad:
		$Player.position.x = global.playerStartX
		$Player.position.y = global.playerStartY
	else:
		$Player.position.x = global.exitCliffsideX
		$Player.position.y = global.exitCliffsideY
	
	print("player x: ", $Player.position.x)
	print("player y: ", $Player.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cliffside_transition_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		get_tree().change_scene_to_file("res://Scenes/cliffside.tscn")
		global.currentScene = "Cliffside"
		global.firstLoad = false
