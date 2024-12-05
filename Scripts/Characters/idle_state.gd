extends NodeState


@export var player: Player
@export var animationPlayer: AnimationPlayer

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.dmgCldwn:
		player.move_and_slide()
	
	match player.direction:
		Vector2.RIGHT:
			animationPlayer.play("idle_side")
		Vector2.LEFT:
			animationPlayer.play("idle_side")
		Vector2.UP:
			animationPlayer.play("idle_back")
		Vector2.DOWN:
			animationPlayer.play("idle_front")

func _on_next_transitions() -> void:
	if InputEvents.movement_input():
		transition.emit("Walk")
		
	if not player.currentTool == global.Tools.None and InputEvents.use_tool():
		transition.emit("Tool")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animationPlayer.stop()
