extends StaticBody2D

const TYPE = global.Types.Choppable

enum States {
	Growing,
	Grown,
	Chopped
}
var state: States = States.Growing

var playerInArea: bool = false
var player: CharacterBody2D = null

var maxHealth: int = 75
var health: int = maxHealth


var logDrop = preload("res://Scenes/collectible.tscn")


func _ready() -> void:
	$HealthBar.max_value = health
	update_health()
	
	$GrowthTimer.wait_time = randi_range(10,20)
	$GrowthTimer.start()
	$AnimationPlayer.play("growing")
	
func _on_growth_timer_timeout() -> void:
	maxHealth += 50
	health += 50
	$HealthBar.max_value = maxHealth
	update_health()
	
	state = States.Grown
	$AnimationPlayer.play('grown')


func _physics_process(delta: float) -> void:
	pass


func take_damage(attack: Attack):
	health -= attack.attackDamage * attack.attackMultiplier
	
	update_health()
	if health <= 0:
		die()

func die():
	$HealthBar.visible = false
	
	if state == States.Grown:
		state = States.Chopped
		$AnimationPlayer.play('chopped')
		
		for drop in range(0, 4):
			drop_log()
	elif state == States.Growing:
		$GrowthTimer.stop()
		state = States.Chopped
		$AnimationPlayer.play('chopped_small')
		
		drop_log()

func drop_log():
	$Marker2D.position.x = randi_range(-15,15)
	$Marker2D.position.y = randi_range(12,20)
	
	var logInst = logDrop.instantiate()
	logInst.set_type("oak_log")
	logInst.global_position = $Marker2D.global_position
	get_parent().add_child(logInst)


func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	$HealthBar/Label.text = str(healthbar.value)
	
	if health >= maxHealth:
		healthbar.visible = false
		health = maxHealth
	else:
		healthbar.visible = true
