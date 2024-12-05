extends NodeState


@export	 var number: int

@export var player: Player
@export var animation: AnimationPlayer

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.dmgCldwn:
		player.move_and_slide()
	
	match player.direction:
		Vector2.RIGHT:
			animatedSprite2D.flip_h = false
			animatedSprite2D.play("idle_side")
		Vector2.LEFT:
			animatedSprite2D.flip_h = true
			animatedSprite2D.play("idle_side")
		Vector2.UP:
			animatedSprite2D.play("idle_back")
		Vector2.DOWN:
			animatedSprite2D.play("idle_front")

func _on_next_transitions() -> void:
	if InputEvents.movement_input():
		transition.emit("Walk")
		
	if not player.currentTool == global.Tools.None and InputEvents.use_tool():
		transition.emit("Tool")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
	
