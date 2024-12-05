class_name InputEvents

static var direction: Vector2

static func movement_input() -> Vector2:
	direction = Input.get_vector("left", "right", "up", "down")
	
	return direction
	
static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true


static func use_tool() -> bool:
	var useToolValue: bool = Input.is_action_pressed("use_tool")
	
	return useToolValue

static func use_item() -> bool:
	var useItemValue: bool = Input.is_action_just_pressed("use_item")
	
	return useItemValue
