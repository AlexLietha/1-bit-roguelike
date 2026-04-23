extends Node
class_name InputComponent

var input_direction: Vector2i = Vector2i.ZERO

func update():
	input_direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
	
	if abs(input_direction.x) == (sqrt(2)/2) or abs(input_direction.y) == sqrt(2)/2:
		input_direction = Vector2i.ZERO
