extends CharacterBody2D

const TYPE = "PLAYER"

var direction  = "e"
var moving = false

const BASE_SPEED = 100
var speed = BASE_SPEED

const BASE_HEALTH = 150
var health = BASE_HEALTH
var dmgCldwn = false

var damage = 25
var enemyInAtkRange = false
var attacking = false

func _ready() -> void:
	$HealthBar.max_value = BASE_HEALTH

func _physics_process(delta: float) -> void:
	# Player movement
	var inputDir = Input.get_vector("left", "right", "up", "down")
	
	velocity = inputDir * BASE_SPEED
	
	move_and_slide()
	get_direction(velocity)
	play_animation()
	
	# Schizo way of doing combat, has to be a better way
	enemy_attack()
	attack()
	
	update_health()
	
	# Player death
	if health <= 0:
		print("\nPlayer killed")
		
		# Respawn placeholder
		self.position.x = global.playerStartX
		self.position.y = global.playerStartY
		health = BASE_HEALTH

func get_direction(vector):
	if vector.x == 100 and vector.y == 0:
		direction = 'e'
		moving = true
	elif vector.x == -100 and vector.y == 0:
		direction = 'w'
		moving = true
	elif vector.x == 0 and vector.y == 100:
		direction = 's'
		moving = true
	elif vector.x == 0 and vector.y == -100:
		direction = 'n'
		moving = true
	elif vector.x == 0 and vector.y == 0:
		moving = false


# Animations
func play_animation():
	var dir = direction
	var anim = $AnimatedSprite2D
	
	match direction:
		"e":
			anim.flip_h = false
			
			if moving and not attacking:
				anim.play("walk_side")
			elif attacking:
				anim.play("attack_side")
			elif not moving and not attacking:
				anim.play("idle_side")
		"w":
			anim.flip_h = true
			
			if moving and not attacking:
				anim.play("walk_side")
			elif attacking:
				anim.play("attack_side")
			elif not moving and not attacking:
				anim.play("idle_side")
		"n":
			if moving and not attacking:
				anim.play("walk_back")
			elif attacking:
				anim.play("attack_back")
			elif not moving and not attacking:
				anim.play("idle_back")
		"s":
			if moving and not attacking:
				anim.play("walk_front")
			elif attacking:
				anim.play("attack_front")
			elif not moving and not attacking:
				anim.play("idle_front")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "ENEMY":
		enemyInAtkRange = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "ENEMY":
		enemyInAtkRange = false
		
func enemy_attack():
	if enemyInAtkRange and not dmgCldwn:
		health -= 10
		print("\nHealth: ", health)
		dmgCldwn = true
		$DamageCooldown.start()

func _on_damage_cooldown_timeout() -> void:
	dmgCldwn = false
	
func attack():
	var dir = direction
	var sprite = $AnimatedSprite2D

	if Input.is_action_just_pressed("attack") and not attacking:
		global.playerAttacking = true
		attacking = true
		speed = 50
		
		$AttackCooldown.start()

func _on_attack_cooldown_timeout() -> void:
	speed = BASE_SPEED
	global.playerAttacking = false
	attacking = false


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
