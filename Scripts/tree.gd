extends StaticBody2D

var state = "growing" # growing, grown, chopped
var playerInArea = false

var logDrop = preload("res://Scenes/collectible.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GrowthTimer.wait_time = randi_range(10,20)
	$GrowthTimer.start()
	$AnimationPlayer.play("growing")

func _physics_process(delta: float) -> void:
	if playerInArea:
		if Input.is_action_just_pressed("use_item"):
			if state == "grown":
				state = "chopped"
				$AnimationPlayer.play('chopped')
				
				for drop in range(0, 4):
					drop_log()
			elif state == "growing":
				$GrowthTimer.stop()
				state = "chopped"
				$AnimationPlayer.play('chopped_small')
				
				drop_log()


func _on_growth_timer_timeout() -> void:
	state = "grown"
	$AnimationPlayer.play('grown')


func _on_interact_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		playerInArea = true

func _on_interact_body_exited(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == "PLAYER":
		playerInArea = false

func drop_log():
	$Marker2D.position.x = randi_range(-15,15)
	$Marker2D.position.y = randi_range(12,20)
	
	var logInst = logDrop.instantiate()
	logInst.set_type("oak_log")
	logInst.global_position = $Marker2D.global_position
	get_parent().add_child(logInst)
