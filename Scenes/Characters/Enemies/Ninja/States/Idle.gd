extends EnemyState

func enter() -> void:
	enemy.animation_player.play(GameConstants.ANIM_IDLE)

func update(_delta: float) -> void:
	pass
	#if not enemy.is_on_floor():
		#print('enemy is floating')
