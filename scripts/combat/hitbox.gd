extends Area2D

export (int) var damage = 1
export (Vector2) var knockback_direction = Vector2.ZERO setget set_knockback_direction
export (int) var knockback_stregth = 100

func active():
	monitorable = true
	
func disactive():
	monitorable = false

func set_knockback_direction(value: Vector2):
	knockback_direction = value.clamped(1) * knockback_stregth
