extends Node2D

@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready() -> void:
	sprite.play()

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if typeof(body) == typeof(Player):
		var p: Player = body
		p.add_coin(1)
		get_parent().remove_child(self)
		queue_free()
