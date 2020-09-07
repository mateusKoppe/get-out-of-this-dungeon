extends KinematicBody2D

export var MAX_SPEED = 80
export var ACCELERATION = 12
export var FRICTION = 20

export var max_hp = 1
onready var hp = max_hp setget set_hp

const Hitbox = preload("res://scripts/combat/hitbox.gd")

enum {
	IDLE,
	MOVE,
	ATTACK
}

var state = IDLE
var move_direction = Vector2.ZERO
var input_direction = Vector2.ZERO

onready var hitbox = $HitboxPosition/Hitbox
onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func get_input_direction():
	input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	return input_direction

func _physics_process(delta):
	match state:
		IDLE:
			state_idle()
		
		MOVE:
			state_move()
			
		ATTACK:
			state_attack()

	move_and_slide(move_direction)
	
func state_idle():
	var input_direction = get_input_direction()
	move_direction = move_direction.move_toward(input_direction * MAX_SPEED, FRICTION)
	animation_state.travel("Idle")
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif input_direction != Vector2.ZERO:
		state = MOVE

func state_move():
	var input_direction = get_input_direction()
	
	if input_direction == Vector2.ZERO:
		state = IDLE
		return
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		return
	
	move_direction = move_direction.move_toward(input_direction * MAX_SPEED, ACCELERATION)
	hitbox.knockback_direction = input_direction
	animation_tree.set("parameters/Idle/blend_position", input_direction)
	animation_tree.set("parameters/Run/blend_position", input_direction)
	animation_tree.set("parameters/Attack/blend_position", input_direction)
	print(input_direction)
	animation_state.travel("Run")
		
func state_attack():
	animation_state.travel("Attack")
	move_direction = move_direction.move_toward(Vector2.ZERO * MAX_SPEED, FRICTION)

func set_hp(value: int):
	if value <= 0:
		queue_free()
	hp = value
	
func on_attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area: Hitbox):
	if area.knockback_direction:
		# TODO: Set this to work with friction instead of ACCELERATION
		move_direction += area.knockback_direction
	if area.damage:
		self.hp -= area.damage
