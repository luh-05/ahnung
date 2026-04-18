extends Node2D

@export var leader: Node2D
@onready var camera: Camera2D = get_node("Camera2D")
@export var follow_strength := 0.2
@export var follow_margin := 1.0
@export var base_zoom: float = 1.5
@export var velocity_factor_lerp: float = 1.0
@export var velocity_factor_zoom: float = 1.0
@export var zoom_strength: float = 0.2
@export var lookahead_factor: float = 2.0

func _ready() -> void:
	camera.zoom = Vector2(base_zoom, base_zoom)

func _process(delta: float) -> void:
	#if camera.position.distance_to(leader.position) > follow_margin:
	#var goal = leader.position
	var vel_factor: float = 0.0
	
	var dist = camera.position.distance_to(leader.position)
	var dir = camera.position.direction_to(leader.position)
	
	var goal = dir * dist * lookahead_factor
	var dist_to_goal = camera.position.distance_to(goal)
	
	goal = leader.position.move_toward(goal, follow_margin)
	
	if typeof(leader) == typeof(Player):
		var p: Player = leader
		vel_factor = dist_to_goal * velocity_factor_lerp * delta
		
		var goal_zoom: float = base_zoom
		goal_zoom -= dist * velocity_factor_zoom / 500
		
		var zoom_delta = camera.zoom.x - goal_zoom
		#zoom_delta *= velocity_factor_zoom
		
		var zoom_lerp = zoom_delta * zoom_strength * delta
		
		camera.zoom -= Vector2(zoom_lerp, zoom_lerp) 
	
	camera.position = camera.position.lerp(goal, (follow_strength + vel_factor) * delta)
