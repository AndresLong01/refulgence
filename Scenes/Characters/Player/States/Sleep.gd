extends PlayerState
class_name Sleep

@onready var fall: Fall = $"../Fall"

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_START_SLEEP)
	player.animation_player.connect("animation_finished", on_start_animation_finished)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		fall.set_slip_buffer()
		Transitioned.emit("fall")
	
	if player.is_on_floor():
		check_for_jump_input()
	
	check_for_attack_input()
	check_for_dash_input()

func physics_update(_delta: float) -> void:
	if (player.velocity.x != 0):
		Transitioned.emit("move")

func exit():
	player.animation_player.disconnect("animation_finished", on_start_animation_finished)

func on_start_animation_finished(animation_name: String) -> void:
	if animation_name == GameConstants.ANIM_START_SLEEP:
		player.animation_player.play(GameConstants.ANIM_SLEEP)
