extends Node2D

@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")
@export var player: Player
var player_grounded: bool = false

func _ready() -> void:
	animation.play()
	

func _physics_process(_delta: float) -> void:
	if player_grounded && !player.is_on_floor():
		animation.play("jump")
		player_grounded = false
		return
	
	if !player_grounded && player.is_on_floor():
		animation.play("landing")
		player_grounded = true
		return

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "landing":
		animation.play("default")
