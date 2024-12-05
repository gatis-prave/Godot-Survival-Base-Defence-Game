extends  Player
#extends CharacterBody2D

#const TYPE = global.Types.Player
#
#var direction: Vector2 = Vector2.RIGHT
#
#const BASE_SPEED = 75
#var speed = BASE_SPEED
#var canMove: bool = true
#
#const BASE_HEALTH = 150
#var health = BASE_HEALTH
#var dmgCldwn = false
#
#var damage: float = 25.0
#var knockback: float = 15.0
#
#var targets: Array = []
#
#@export var currentTool: global.Tools = global.Tools.None
#var wpnAreaSide: CollisionPolygon2D
#var wpnAreaFront: CollisionPolygon2D

var toolArea: CollisionShape2D
var sprite: Sprite2D

func _ready() -> void:
	wpnAreaSide = $WeaponArea/Side
	wpnAreaFront = $WeaponArea/Front
	toolArea = $WeaponArea/Tool
	sprite = $Sprite2D
	
	$HealthBar.max_value = BASE_HEALTH
	wpnAreaSide.disabled = true
	wpnAreaFront.disabled = true
	toolArea.disabled = true
	
func _physics_process(delta: float) -> void:
	
	#print(canMove)
	#print(direction)
	#print("Side: ", wpnAreaSide.disabled)
	#print("Front: ", wpnAreaFront.disabled)
	get_direction()
	
	#attacking()
	
	update_health()

func get_direction():
	var moveInput: Vector2 = InputEvents.movement_input()
	
	if canMove:
		if moveInput.x > 0.7:
			direction = Vector2.RIGHT
		elif moveInput.x < -0.7:
			direction = Vector2.LEFT
		elif moveInput.y > 0.7:
			direction = Vector2.DOWN
		elif moveInput.y < -0.7:
			direction = Vector2.UP
	
		match direction:
			Vector2.RIGHT:
				sprite.flip_h = false
				
				toolArea.position = Vector2(11, -3)
				toolArea.scale = Vector2(1, 1)
				
				wpnAreaSide.visible = true
				wpnAreaFront.visible = false
				
				wpnAreaSide.scale.x = 1
			Vector2.LEFT:
				sprite.flip_h = true
				
				toolArea.position = Vector2(-11, -3)
				toolArea.scale = Vector2(1, 1)
				
				wpnAreaSide.visible = true
				wpnAreaFront.visible = false
				
				wpnAreaSide.scale.x = -1
			Vector2.UP:
				toolArea.position = Vector2(0, -13)
				toolArea.scale = Vector2(0.5, 3)
				
				wpnAreaSide.visible = false
				wpnAreaFront.visible = true
				
				wpnAreaFront.scale.y = 1
			Vector2.DOWN:
				toolArea.position = Vector2(1, 9)
				toolArea.scale = Vector2(0.5, 1.4)
				
				wpnAreaSide.visible = false
				wpnAreaFront.visible = true
				
				wpnAreaFront.scale.y = -0.9


func _on_weapon_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and not body.TYPE == global.Types.Player:
		var attack  = Attack.new()
		attack.attackDamage = damage
		attack.attackPosition = global_position
		attack.knockbackForce = knockback
		
		attack.attackMultiplier = attack.get_multiplier(currentTool, body.TYPE)
		body.take_damage(attack)
	
	#print(targets)
#
#func _on_weapon_area_body_exited(body: Node2D) -> void:
	#if body in targets:
		#targets.erase(body)
		#
	#print(targets)

func attacking():
	var attack  = Attack.new()
	attack.attackDamage = damage
	attack.attackPosition = global_position
	attack.knockbackForce = knockback
	
	for target in targets:
		attack.attackMultiplier = attack.get_multiplier(currentTool, target.TYPE)
		target.take_damage(attack)



func take_damage(attack: Attack):
	if not dmgCldwn:
		health -= attack.attackDamage * attack.attackMultiplier
		velocity = (global_position - attack.attackPosition).normalized() * attack.knockbackForce
		
		dmgCldwn = true
		$Timers/DamageCooldown.start()
		
		update_health()
		
		if health <= 0:
			die_and_respawn()
		
	
func _on_damage_cooldown_timeout() -> void:
	dmgCldwn = false

func die_and_respawn():
	print("\nPlayer killed")
	
	# Respawn placeholder
	self.position.x = global.playerStartX
	self.position.y = global.playerStartY
	health = BASE_HEALTH


func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= BASE_HEALTH:
		healthbar.visible = false
		health = BASE_HEALTH
	else:
		healthbar.visible = true

func _on_regen_timeout() -> void:
	if health < BASE_HEALTH:
		health += 10
