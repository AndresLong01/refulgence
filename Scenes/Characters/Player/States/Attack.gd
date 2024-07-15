extends PlayerState
class_name Attack

@onready var reset_combo = $ResetCombo

const ATTACK_BUFFER_FRAMES: int = 16
const HITBOX_DISPLACEMENT: int = 23

var attack_buffer_counter: int = 0
var combo_counter: int = 1
var max_combo_count: int = 2

func enter() -> void:
	player.toggle_horizontal_input(false)
	animate_attack_combo()
	player.animation_player.connect("animation_finished", _on_animation_finished)

func update(_delta: float) -> void:
	if (player.sprite.flip_h and Input.is_action_pressed(GameConstants.INPUT_RIGHT) or 
		not player.sprite.flip_h and Input.is_action_pressed(GameConstants.INPUT_LEFT)):
		check_for_backdash_input()
		return
	
	check_for_dash_input()

func physics_update(delta : float) -> void:
	calculate_buffer()
	player.velocity.y += player.GRAVITY * delta

func exit() -> void:
	player.toggle_horizontal_input(true)
	# Disable lasting hitboxes if exiting state early. 
	#NOTE Might need a rework for multiple hitboxes (future)
	var hitbox_collider: CollisionShape2D = player.hitbox.get_child(0)
	if !hitbox_collider.disabled:
		hitbox_collider.disabled = true
	player.animation_player.disconnect("animation_finished", _on_animation_finished)
	
	reset_combo.start()

func attack() -> void:
	var new_position: Vector2
	if player.sprite.flip_h:
		new_position = Vector2(-HITBOX_DISPLACEMENT, -2)
	else:
		new_position = Vector2(HITBOX_DISPLACEMENT, -2)
	
	player.hitbox.position = new_position

func animate_attack_combo() -> void:
	player.animation_player.play(GameConstants.ANIM_ATTACK + str(combo_counter))
	
	combo_counter += 1
	combo_counter = wrap(combo_counter, 1, max_combo_count + 1)

func calculate_buffer() -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_ATTACK):
		attack_buffer_counter = ATTACK_BUFFER_FRAMES
	
	if attack_buffer_counter > 0:
		attack_buffer_counter -= 1

func _on_animation_finished(_animation_name: String) -> void:
	if attack_buffer_counter > 0:
		animate_attack_combo()
	else:
		Transitioned.emit("idle")

func _on_reset_combo_timeout() -> void:
	combo_counter = 1
