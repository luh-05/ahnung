extends Node2D

@export var leader: Node2D
@onready var camera: Camera2D = get_node("Camera2D")
@export var follow_strength := 1.5
@export var follow_margin := 50.0
func _process(delta: float) -> void:
	#if camera.position.distance_to(leader.position) > follow_margin:
	camera.position = camera.position.lerp(leader.position.move_toward(camera.position, follow_margin), follow_strength * delta)
