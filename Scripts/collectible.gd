extends StaticBody2D

enum TYPES {OAK_LOG, GOLD}
var type: String

func set_type(name):
	type = name
	$Sprite2D/AnimationPlayer.play(type)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "TYPE" in body and body.TYPE == global.Types.Player:
		print("+1 ", type)
		self.queue_free()
