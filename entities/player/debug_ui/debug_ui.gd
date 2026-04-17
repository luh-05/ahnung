extends Control

@export var player: Player = null

var player_speed_lbl: Label
var vel_lbl: Label
var fric_lbl: Label

func _ready() -> void:
	player_speed_lbl = get_node("VBoxContainer/PlayerSpeed")
	vel_lbl = get_node("VBoxContainer/Velocity")
	fric_lbl = get_node("VBoxContainer/Friction")

func _process(_delta: float) -> void:
	#player_speed_lbl.text = "Player Movement: " + str(player.current_move_velocity)
	vel_lbl.text = "Player general Velocity: " + str(player.velocity)
	fric_lbl.text = "Player Friction: " + str(player.cur_friction)
