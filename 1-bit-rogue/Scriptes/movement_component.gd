extends Node
class_name MovementComponent

@export var sprite: Node2D 
@export var speed := 1
var direction: Vector2i = Vector2i.ZERO
var locked_pos: Vector2i
var map_pos: Vector2i

signal moved

var moving := false
func update(delta: float):
	if !moving and locked_pos == Vector2i.ZERO and direction != Vector2i.ZERO:
		locked_pos = direction * Vector2i(16, 16) + Vector2i(sprite.position)
		moving = true
		map_pos += direction
		moved.emit()
		print("moved")
		
	if moving:
		sprite.position = sprite.position.move_toward(locked_pos, speed * delta)
		
	if Vector2i(sprite.position) == locked_pos:
		moving = false
		locked_pos = Vector2i.ZERO
