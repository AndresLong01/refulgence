extends PlayerState
class_name AirAttack

const ATTACK_BUFFER_FRAMES: int = 16

var attack_buffer_counter: int = 0

func enter() -> void:
	attack()
	if not player.animation_player.is_connected("animation_finished", on_animation_finished):
		player.animation_player.connect("animation_finished", on_animation_finished)

func update(_delta: float) -> void:
	check_for_attack_input()

func physics_update(delta: float) -> void:
	calculate_buffer()
	player.velocity.y += player.GRAVITY * delta
	
	if player.is_on_floor():
		player.velocity.y = 0
		Transitioned.emit("idle")

func exit() -> void:
	player.animation_player.disconnect("animation_finished", on_animation_finished)

func attack() -> void:
	player.animation_player.play(GameConstants.ANIM_AIR_ATTACK)

func calculate_buffer() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_ATTACK):
		attack_buffer_counter = ATTACK_BUFFER_FRAMES
	
	if attack_buffer_counter > 0:
		attack_buffer_counter -= 1

func on_animation_finished(animation_name: String) -> void:
	if attack_buffer_counter > 0:
		attack()
	else:
		Transitioned.emit("idle")
