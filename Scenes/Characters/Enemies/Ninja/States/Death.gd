extends EnemyState

func enter() -> void:
	print("entered death")
	enemy.animation_player.play(GameConstants.ANIM_DEATH)
	enemy.animation_player.connect("animation_finished", _on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	print("dying")
	#enemy.queue_free()
