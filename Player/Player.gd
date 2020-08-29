extends KinematicBody2D

export var MAX_SPEED = 80
export var ACCELERATION = 12
export var FRICTION = 20

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var move_direction = Vector2.ZERO
var input_direction = Vector2.ZERO
var face_direction = Vector2.RIGHT

func get_input_direction():
	input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	return input_direction

func _physics_process(delta):
	match state:
		MOVE:
			state_move()
			
		ATTACK:
			state_attack()
	
	move_and_slide(move_direction)
	
func state_move():
	var input_direction = get_input_direction()
	if input_direction == Vector2.ZERO:
		move_direction = move_direction.move_toward(input_direction * MAX_SPEED, FRICTION)
	else:
		move_direction = move_direction.move_toward(input_direction * MAX_SPEED, ACCELERATION)
		face_direction = Vector2.LEFT if move_direction.x < 0 else Vector2.RIGHT
		
	if face_direction == Vector2.LEFT:
		$AnimationPlayer.play("IdleLeft")
	else:
		$AnimationPlayer.play("IdleRight")
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func state_attack():
	if face_direction == Vector2.LEFT:
		$AnimationPlayer.play("AttackLeft")
	else:
		$AnimationPlayer.play("AttackRight")
	
	move_direction = move_direction.move_toward(Vector2.ZERO * MAX_SPEED, FRICTION)
	
func on_attack_animation_finished():
	state = MOVE
