extends Node2D

@export var leader: Node2D
@onready var camera: Camera2D = get_node("Camera2D")
@export var follow_strength := 0.2
@export var follow_margin := 1.0
@export var base_zoom: float = 1.5
@export var distance_factor_lerp: float = 1.0
@export var distance_factor_zoom: float = 0.441
@export var zoom_strength: float = 0.2
@export var lookahead_factor: float = 2.0

func _ready() -> void:
	camera.zoom = Vector2(base_zoom, base_zoom)

func _process(delta: float) -> void:
	var dist = camera.position.distance_to(leader.position)
	var dir = camera.position.direction_to(leader.position)
	
	var goal = dir * dist * lookahead_factor
	goal = leader.position.move_toward(goal, follow_margin)
	var dist_to_goal = camera.position.distance_to(goal)
	
	# camera position
	var dist_factor = dist_to_goal * distance_factor_lerp * delta
	
	camera.position = camera.position.lerp(goal, (follow_strength + dist_factor) * delta)
	
	# camera zoom
	var goal_zoom: float = base_zoom
	goal_zoom -= dist_to_goal * distance_factor_zoom / 500
	var zoom_delta = camera.zoom.x - goal_zoom
	var zoom_lerp = zoom_delta * zoom_strength * delta
	
	camera.zoom -= Vector2(zoom_lerp, zoom_lerp) 
	
