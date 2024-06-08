extends State
class_name PlayerState

@export var player: Player

func check_for_jump_input() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_JUMP):
		Transitioned.emit("jump")

func check_for_attack_input() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_ATTACK):
		if player.is_on_floor():
			Transitioned.emit("attack")
		else:
			Transitioned.emit("airattack")

func check_for_dash_input() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_DASH):
		Transitioned.emit("dash")
