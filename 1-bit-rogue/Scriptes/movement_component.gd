extends Node
class_name MovementComponent

@export var sprite: Sprite2D 
var direction: Vector2i = Vector2i.ZERO
# Called when the node enters the scene tree for the first time.
func update():
	sprite.position += Vector2(direction * 16)
