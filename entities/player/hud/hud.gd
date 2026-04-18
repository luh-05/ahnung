extends Control

@export var player: Player
@onready var coin_label: Label = get_node("CoinDisplay/Label")
@onready var coin_sprite: AnimatedSprite2D = get_node("CoinDisplay/AnimatedSprite2D")


func _ready() -> void:
	coin_sprite.play()

func _on_player_body_pickup_signal(coin_count) -> void:
	coin_label.text = str(coin_count)
