extends Node2D

@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")


func _ready() -> void:
	animation.play()
