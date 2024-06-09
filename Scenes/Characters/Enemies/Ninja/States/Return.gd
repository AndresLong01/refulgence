extends EnemyState

func enter() -> void:
	enemy.animation_player.play(GameConstants.ANIM_MOVE)
	enemy.destination = enemy.get_point_global_position(0)
	enemy.navigation_agent.target_position = enemy.destination

func physics_update(_delta: float) -> void:
	if enemy.navigation_agent.is_navigation_finished():
		Transitioned.emit("idle")
		return
	
	enemy.move()
