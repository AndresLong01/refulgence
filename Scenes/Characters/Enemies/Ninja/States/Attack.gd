extends EnemyState

func enter():
	enemy.animation_player.play(GameConstants.ANIM_ATTACK)
