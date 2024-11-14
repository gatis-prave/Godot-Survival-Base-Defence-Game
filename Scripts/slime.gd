extends CharacterBody2D

const TYPE = "ENEMY"

var moveSpeed = 40
var target = null
var targetChase = false

const BASE_HEALTH = 75
var health = BASE_HEALTH
var dmgCldwn = false

var damage = 15
var playerInRange = false

func _ready() -> void:
	$HealthBar.max_value = BASE_HEALTH

func _physics_process(delta: float) -> void:
	if targetChase:
		position += (target.position - position).normalized() * moveSpeed * delta
			
		$AnimatedSprite2D.flip_h = (position > target.position)
	
	check_damage()
	
	update_health()
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	target = body
	targetChase = true
	$AnimatedSprite2D.play("move")


func _on_detection_area_body_exited(body: Node2D) -> void:
	target = null
	targetChase = false
	$AnimatedSprite2D.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		playerInRange = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		playerInRange = false


func check_damage():
	if playerInRange and global.playerAttacking and not dmgCldwn:
		health -= target.damage
		print("\nSlime health: ", health)
		dmgCldwn = true
		$DamageCooldown.start()
		if health <= 0:
			$AnimatedSprite2D.play("death")
			self.queue_free()

# Reset damage cooldown
func _on_damage_cooldown_timeout() -> void:
	dmgCldwn = false
	
	
func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= BASE_HEALTH:
		healthbar.visible = false
		health = BASE_HEALTH
	else:
		healthbar.visible = true
