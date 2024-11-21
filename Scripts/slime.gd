extends CharacterBody2D

const TYPE = "ENEMY"

const BASE_SPEED = 40
var speed = BASE_SPEED
var target = null
var targetChase = false

const BASE_HEALTH = 75
var health = BASE_HEALTH
var dmgCldwn = false

var damage = 15

func _ready() -> void:
	$HealthBar.max_value = BASE_HEALTH
	update_health()


func _physics_process(delta: float) -> void:
	
	if targetChase:
		var targetPos = (target.position - position).normalized()
		if not dmgCldwn:
			velocity = targetPos * speed
		print(velocity)
	
		$AnimatedSprite2D.flip_h = (position > target.position)
	
	#velocity = Vector2.ZERO
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	target = body
	targetChase = true
	$AnimatedSprite2D.play("move")


func _on_detection_area_body_exited(body: Node2D) -> void:
	target = null
	targetChase = false
	$AnimatedSprite2D.play("idle")


func take_damage(attack: Attack):
	if not dmgCldwn:
		health -= attack.attackDamage
		velocity = (global_position - attack.attackPosition).normalized() * attack.knockbackForce
		
		dmgCldwn = true
		$DamageCooldown.start()
		
		if health <= 0:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("death")
			await get_tree().create_timer(0.7).timeout
			self.queue_free()
		update_health()

# Reset damage cooldown
func _on_damage_cooldown_timeout() -> void:
	dmgCldwn = false
	velocity = Vector2.ZERO
	
	
func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= BASE_HEALTH:
		healthbar.visible = false
		health = BASE_HEALTH
	else:
		healthbar.visible = true
