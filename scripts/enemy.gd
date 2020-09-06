extends KinematicBody2D

export var MAX_SPEED = 20
export var ACCELERATION = 5
export var max_hp = 1
onready var hp = max_hp setget set_hp

const Hitbox = preload("res://scripts/combat/hitbox.gd")

var move_direction = Vector2.ZERO
var target_direction = Vector2.ZERO

func _physics_process(delta):
	var direction = global_position.direction_to(target_direction)
	move_direction = move_direction.move_toward(direction * MAX_SPEED, ACCELERATION)
	move_and_slide(move_direction)
	
func set_hp(value: int):
	if value <= 0:
		queue_free()
	hp = value

func _on_Wander_new_target_position(direction: Vector2):
	target_direction = direction

func _on_Hurtbox_area_entered(area: Hitbox):
	if area.knockback_direction:
		# TODO: Set this to work with friction instead of ACCELERATION
		move_direction += area.knockback_direction
	if area.damage:
		self.hp -= area.damage
