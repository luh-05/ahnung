extends Node2D

@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready() -> void:
	sprite.play()

func remove_self() -> void:
	get_parent().remove_child(self)

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if typeof(body) == typeof(Player):
		var p: Player = body
		p.add_coin(1)
		call_deferred("remove_self")
		queue_free()
