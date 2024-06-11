extends EnemyState

const RUN_SPEED: float = 80.0

func enter() -> void:
	enemy.enemy_speed = RUN_SPEED
	enemy.animation_player.play(GameConstants.ANIM_MOVE)
	enemy.chase_area.connect("body_entered", _on_chase_area_body_entered)
	
	enemy.destination = enemy.get_point_global_position(0)
	enemy.navigation_agent.target_position = enemy.destination

func physics_update(delta: float) -> void:
	if enemy.navigation_agent.is_navigation_finished():
		Transitioned.emit("patrol")
		return
	
	enemy.move(delta)

func exit() -> void:
	enemy.chase_area.disconnect("body_entered", _on_chase_area_body_entered)
