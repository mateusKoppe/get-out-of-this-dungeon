extends KinematicBody2D

export var MAX_SPEED = 20
export var ACCELERATION = 5
export var max_hp = 1

enum {
	WANDER,
	CHASE
}

const Hitbox = preload("res://scripts/combat/hitbox.gd")
onready var hitbox = $Hitbox

var move_direction = Vector2.ZERO
var wander_direction = Vector2.ZERO
var chase_enemy = null 
var state = WANDER
onready var hp = max_hp setget set_hp

func _physics_process(delta):
	var direction = Vector2.ZERO
	match (state):
		WANDER:
			direction = global_position.direction_to(wander_direction)
			move_to_direction(direction)
			
		CHASE:
			if not chase_enemy:
				state = WANDER
				return
			direction = global_position.direction_to(chase_enemy.global_position)
			move_to_direction(direction)

func move_to_direction(direction: Vector2):
	move_direction = move_direction.move_toward(direction * MAX_SPEED, ACCELERATION)
	hitbox.knockback_direction = move_direction
	move_and_slide(move_direction)
	
func set_hp(value: int):
	if value <= 0:
		queue_free()
	hp = value

func _on_Wander_new_target_position(direction: Vector2):
	if state == WANDER:
		wander_direction = direction

func _on_Hurtbox_area_entered(area: Hitbox):
	if area.knockback_direction:
		# TODO: Set this to work with friction instead of ACCELERATION
		move_direction += area.knockback_direction
	if area.damage:
		self.hp -= area.damage

func _on_PlayerDetection_player_entered(enemy: KinematicBody2D):
	state = CHASE
	chase_enemy = enemy

func _on_PlayerDetection_player_exited(enemy: KinematicBody2D):
	state = WANDER
	chase_enemy = null
