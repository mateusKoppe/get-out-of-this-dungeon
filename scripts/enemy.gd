extends KinematicBody2D

export var MAX_SPEED = 20
export var ACCELERATION = 5

var move_direction = Vector2.ZERO
var target_direction = Vector2.ZERO

func _physics_process(delta):
	var direction = global_position.direction_to(target_direction)
	move_direction = move_direction.move_toward(direction * MAX_SPEED, ACCELERATION)
	move_and_slide(move_direction)

func _on_Wander_new_target_position(direction):
	target_direction = direction
