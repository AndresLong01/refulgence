extends PlayerState
class_name Move

@onready var fall: Fall = $"../Fall"

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_START_MOVE)
	player.animation_player.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		fall.set_slip_buffer()
		Transitioned.emit("fall")
	
	if player.is_on_floor():
		check_for_jump_input()
	
	check_for_attack_input()
	check_for_dash_input()

func exit() -> void:
	player.animation_player.disconnect("animation_finished", _on_animation_finished)

func physics_update(_delta) -> void:
	if player.velocity.x == 0:
		Transitioned.emit("idle")

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == GameConstants.ANIM_START_MOVE:
		player.animation_player.play(GameConstants.ANIM_MOVE)
