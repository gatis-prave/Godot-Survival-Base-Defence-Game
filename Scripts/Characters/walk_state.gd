extends NodeState


@export var player: Player
@export var animationPlayer: AnimationPlayer
@export var speed: int

var wpnAreaSide: CollisionPolygon2D
var wpnAreaFront: CollisionPolygon2D


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	# Walk animation
	match player.direction:
		Vector2.RIGHT:
			animationPlayer.play("walk_side")
		Vector2.LEFT:
			animationPlayer.play("walk_side")
		Vector2.UP:
			animationPlayer.play("walk_back")
		Vector2.DOWN:
			animationPlayer.play("walk_front")
	
	# Apply movement with input vector
	if not player.dmgCldwn:
		player.velocity = InputEvents.movement_input() * speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	if not player.currentTool == global.Tools.None and InputEvents.use_tool():
		transition.emit("Tool")
	
	if not InputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	speed = player.BASE_SPEED
	wpnAreaSide = player.wpnAreaSide
	wpnAreaFront = player.wpnAreaFront


func _on_exit() -> void:
	animationPlayer.stop()
