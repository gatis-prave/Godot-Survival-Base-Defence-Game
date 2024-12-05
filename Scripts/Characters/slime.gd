extends CharacterBody2D

const TYPE = global.Types.Enemy

const BASE_SPEED = 40
var speed = BASE_SPEED
var target = null
var targetChase = false
var targetDistance: float

const BASE_HEALTH = 75
var health = BASE_HEALTH

var damage: float = 5.0
var knockback: float = 80.0

func _ready() -> void:
	$HealthBar.max_value = BASE_HEALTH
	update_health()


func _physics_process(delta: float) -> void:
	if targetChase:
		var targetPos = (target.position - position).normalized()
		velocity = targetPos * speed
	
		$AnimatedSprite2D.flip_h = (position > target.position)
		
		targetDistance = position.distance_to(target.position)
		if targetDistance < 15.0:
			attack_target()
			
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	target = body
	targetChase = true
	$AnimatedSprite2D.play("move")


func _on_detection_area_body_exited(body: Node2D) -> void:
	target = null
	targetChase = false
	$AnimatedSprite2D.play("idle")


func attack_target():
	var attack  = Attack.new()
	attack.attackDamage = damage
	attack.attackPosition = global_position
	attack.knockbackForce = knockback
	
	if not target == null:
		attack.attackMultiplier = attack.get_multiplier(global.Tools.None, target.TYPE)
		target.take_damage(attack)


func _on_attack_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func take_damage(attack: Attack):
	health -= attack.attackDamage * attack.attackMultiplier
	velocity = (global_position - attack.attackPosition).normalized() * attack.knockbackForce
	update_health()
	if health <= 0:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(0.7).timeout
		self.queue_free()	
	
func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= BASE_HEALTH:
		healthbar.visible = false
		health = BASE_HEALTH
	else:
		healthbar.visible = true
