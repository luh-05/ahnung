extends Node2D

@export var leader: Node2D
@onready var camera: Camera2D = get_node("Camera2D")
@export var follow_strength := 100
@export var follow_margin := 1.0
func _process(delta: float) -> void:
	#if camera.position.distance_to(leader.position) > follow_margin:
	#var goal = leader.position.move_toward(camera.position, follow_margin)
	var goal = leader.position
	camera.position = camera.position.lerp(goal, follow_strength * delta)
