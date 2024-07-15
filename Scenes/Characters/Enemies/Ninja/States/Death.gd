extends EnemyState

func enter() -> void:
	print("entered death")
	enemy.animation_player.play(GameConstants.ANIM_DEATH)
	if not enemy.animation_player.is_connected("animation_finished", _on_animation_finished):
		enemy.animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	print("dying")
	#enemy.queue_free()
