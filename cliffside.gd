extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_world_transition_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
		global.currentScene = "World"
		print(global.currentScene)
