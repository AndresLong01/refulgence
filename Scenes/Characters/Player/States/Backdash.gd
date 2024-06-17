extends PlayerState
class_name Backdash

const DASH_VELOCITY: float = 150.0

func enter():
	player.toggle_horizontal_input(false)
	player.toggle_ignore_sprite_flip(true)
	
	var direction = 1 if player.sprite.flip_h else -1
	player.velocity.x = DASH_VELOCITY * direction
	
	player.animation_player.play(GameConstants.ANIM_BACKDASH)
	player.animation_player.connect("animation_finished", on_animation_finished)

func physics_update(delta: float) -> void:
	player.velocity.y += player.GRAVITY * delta

func exit():
	player.toggle_horizontal_input(true)
	player.toggle_ignore_sprite_flip(false)
	
	player.velocity.x = 0
	player.animation_player.disconnect("animation_finished", on_animation_finished)

func on_animation_finished(_animation_name: String) -> void:
	Transitioned.emit("idle")
