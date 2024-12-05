extends NodeState


@export var player: Player
@export var animationPlayer: AnimationPlayer

var tool: global.Tools
var wpnAreaSide: CollisionPolygon2D
var wpnAreaFront: CollisionPolygon2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if InputEvents.use_tool():
		if animationPlayer.is_playing():
			player.canMove = false
		else:
			match player.direction:
				Vector2.RIGHT:
					print("use right")
					#wpnAreaSide.disabled = false
					#wpnAreaFront.disabled = true
					match tool:
						global.Tools.Sword:
							animationPlayer.play("attack_side")
						global.Tools.Axe:
							animationPlayer.play("chop_side")
						global.Tools.Pickaxe:
							animationPlayer.play("mine_side")
				Vector2.LEFT:
					#wpnAreaSide.disabled = false
					#wpnAreaFront.disabled = true
					match tool:
						global.Tools.Sword:
							animationPlayer.play("attack_side")
						global.Tools.Axe:
							animationPlayer.play("chop_side")
						global.Tools.Pickaxe:
							animationPlayer.play("mine_side")
				Vector2.UP:
					#wpnAreaSide.disabled = true
					#wpnAreaFront.disabled = false
					match tool:
						global.Tools.Sword:
							animationPlayer.play("attack_back")
						global.Tools.Axe:
							animationPlayer.play("chop_back")
						global.Tools.Pickaxe:
							animationPlayer.play("mine_back")
				Vector2.DOWN:
					#wpnAreaSide.disabled = true
					#wpnAreaFront.disabled = false
					match tool:
						global.Tools.Sword:
							animationPlayer.play("attack_front")
						global.Tools.Axe:
							animationPlayer.play("chop_front")
						global.Tools.Pickaxe:
							animationPlayer.play("mine_front")
			player.canMove = true
		
	#if animationPlayer.is_playing():
		#player.canMove = false
	#else:
		#player.canMove = true

func _on_next_transitions() -> void:
	if not animationPlayer.is_playing():
		player.canMove = true
		transition.emit("Idle")
		#if InputEvents.is_movement_input():
			#transition.emit("Walk")
		#else:
			#transition.emit("Idle")


func _on_enter() -> void:
	tool = player.currentTool
	wpnAreaSide = player.wpnAreaSide
	wpnAreaFront = player.wpnAreaFront

func _on_exit() -> void:
	wpnAreaSide.disabled = true
	wpnAreaFront.disabled = true
