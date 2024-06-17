extends PlayerState

func enter() -> void:
	player.toggle_horizontal_input(false)
	player.animation_player.play(GameConstants.ANIM_DEATH)
	player.animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	player.queue_free()
