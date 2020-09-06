extends Area2D

signal player_entered
signal player_exited

func _on_PlayerDetection_body_entered(body: KinematicBody2D):
	emit_signal("player_entered", body)

func _on_PlayerDetection_body_exited(body: KinematicBody2D):
	emit_signal("player_exited", body)
