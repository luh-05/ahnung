extends Node2D

@export var player: CharacterBody2D
@export var vel_arrow: Line2D

func _process(_delta: float) -> void:
	vel_arrow.set_point_position(1, player.velocity*0.03)
