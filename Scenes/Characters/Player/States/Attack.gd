extends PlayerState
class_name Attack

@onready var reset_combo = $ResetCombo

const ATTACK_BUFFER_FRAMES: int = 16

var attack_buffer_counter: int = 0
var combo_counter: int = 1
var max_combo_count: int = 2

func enter() -> void:
	player.toggle_horizontal_input(false)
	attack()
	player.animation_player.connect("animation_finished", on_animation_finished)

func physics_update(delta) -> void:
	calculate_buffer()
	player.velocity.y += player.GRAVITY * delta

func exit() -> void:
	player.toggle_horizontal_input(true)
	player.animation_player.disconnect("animation_finished", on_animation_finished)
	
	reset_combo.start()

func attack() -> void:
	player.animation_player.play(GameConstants.ANIM_ATTACK + str(combo_counter))
	
	combo_counter += 1
	combo_counter = wrap(combo_counter, 1, max_combo_count + 1)

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

func _on_reset_combo_timeout():
	combo_counter = 1
