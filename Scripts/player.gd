extends CharacterBody2D

const TYPE = "PLAYER"
var state = "idle"

var direction  = "e"
var moving = false

const BASE_SPEED = 100
var speed = BASE_SPEED

const BASE_HEALTH = 150
var health = BASE_HEALTH
var dmgCldwn = false

var damage = 25
var knockback = 40
var enemyInAtkRange = false

func _ready() -> void:
	$HealthBar.max_value = BASE_HEALTH
	$WeaponArea/CollisionShape2D.disabled = true
	
func _physics_process(delta: float) -> void:
	# Player movement
	var inputDir = Input.get_vector("left", "right", "up", "down")
	
	velocity = inputDir * speed
	#print(state)

	
	move_and_slide()
	get_direction(velocity)
	play_animation()
	
	# Schizo way of doing combat, has to be a better way
	enemy_attack()
	attacking()
	
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
		if state == "idle":
			state = "walking"
	elif vector.x == -100 and vector.y == 0:
		direction = 'w'
		if state == "idle":
			state = "walking"
	elif vector.x == 0 and vector.y == 100:
		direction = 's'
		if state == "idle":
			state = "walking"
	elif vector.x == 0 and vector.y == -100:
		direction = 'n'
		if state == "idle":
			state = "walking"
	elif vector.x == 0 and vector.y == 0:
		if not state == "idle" and not state == "attacking":
			state = "idle"
	

# Animations
func play_animation():
	var dir = direction
	var anim = $AnimatedSprite2D
	var wpnArea = $WeaponArea/CollisionShape2D
	
	match direction:
		"e":
			anim.flip_h = false
			wpnArea.position = Vector2(5,1)
			wpnArea.rotation = 45
			
			match state:
				"attacking":
					anim.play("attack_side")
				"walking":
					anim.play("walk_side")
				"idle":
					anim.play("idle_side")
		"w":
			anim.flip_h = true
			wpnArea.position = Vector2(-5,1)
			wpnArea.rotation = 135
			
			match state:
				"attacking":
					anim.play("attack_side")
				"walking":
					anim.play("walk_side")
				"idle":
					anim.play("idle_side")
		"n":
			wpnArea.position = Vector2(-1,-6)
			wpnArea.rotation = 90
			
			match state:
				"attacking":
					anim.play("attack_back")
				"walking":
					anim.play("walk_back")
				"idle":
					anim.play("idle_back")
		"s":
			wpnArea.position = Vector2(0,3)
			wpnArea.rotation = 90
			
			match state:
				"attacking":
					anim.play("attack_front")
				"walking":
					anim.play("walk_front")
				"idle":
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
		$Timers/DamageCooldown.start()

func _on_damage_cooldown_timeout() -> void:
	dmgCldwn = false


func attacking():
	if Input.is_action_just_pressed("attack") and not state == "attacking":
		state = "attacking"
		speed = 50
		$WeaponArea/CollisionShape2D.disabled = false
		
		$Timers/AttackCooldown.start()

func _on_weapon_area_body_entered(body: Node2D) -> void:
	var attack  = Attack.new()
	attack.attackDamage = damage
	attack.attackPosition = global_position
	attack.knockbackForce = knockback
	
	if body.has_method("take_damage"):
		body.take_damage(attack)

func _on_attack_cooldown_timeout() -> void:
	$WeaponArea/CollisionShape2D.disabled = true
	speed = BASE_SPEED
	state = "walking"


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
		
