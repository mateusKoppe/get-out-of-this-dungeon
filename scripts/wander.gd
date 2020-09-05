extends Node2D

export var wander_range = 25
export var around_origin = true
export var target_interval = 3
export var target_interval_range = 0

var target_direction = Vector2.ZERO

const MIN_INTERVAL = 1

onready var start_position = global_position

signal new_target_position

func get_interval_in_range():
	var min_interval = min(MIN_INTERVAL, target_interval - target_interval_range)
	var max_interval = max(MIN_INTERVAL, target_interval + target_interval_range)
	return rand_range(min_interval, max_interval)
	
func get_pivot():
	return start_position if around_origin else global_position

func get_random_direction():
	var direction = Vector2(
		rand_range(-wander_range, wander_range),
		rand_range(-wander_range, wander_range)
	)
	return direction
	
func refresh_target_position():
	var pivot = get_pivot()
	var direction = get_random_direction()
	target_direction = pivot + direction
	emit_signal("new_target_position", target_direction)
	
func start_timeout(duration):
	$Timer.start(duration)

func _ready():
	randomize()
	refresh_target_position()
	start_timeout(get_interval_in_range())

func _on_Timer_timeout():
	refresh_target_position()
	start_timeout(get_interval_in_range())
