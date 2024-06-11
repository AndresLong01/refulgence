extends EnemyState

@export var patrol_timer: Timer
@export var max_idle_time: float = 4.0

const PATROL_SPEED: float = 40.0

var point_index: int = 0

func enter() -> void:
	enemy.enemy_speed = PATROL_SPEED
	enemy.animation_player.play(GameConstants.ANIM_PATROL)
	enemy.navigation_agent.connect("navigation_finished", _on_navigation_finished)
	enemy.chase_area.connect("body_entered", _on_chase_area_body_entered)
	patrol_timer.connect("timeout", _on_patrol_timer_timeout)
	
	point_index = 1
	enemy.destination = enemy.get_point_global_position(point_index)
	enemy.navigation_agent.target_position = enemy.destination

func physics_update(delta) -> void:
	if(!patrol_timer.is_stopped()):
		return
	
	enemy.move(delta)

func exit() -> void:
	enemy.navigation_agent.disconnect("navigation_finished", _on_navigation_finished)
	patrol_timer.disconnect("timeout", _on_patrol_timer_timeout)
	enemy.chase_area.disconnect("body_entered", _on_chase_area_body_entered)

func _on_navigation_finished() -> void:
	enemy.animation_player.play(GameConstants.ANIM_IDLE)
	var random_timeout: RandomNumberGenerator = RandomNumberGenerator.new()
	patrol_timer.wait_time = random_timeout.randf_range(0, max_idle_time)
	
	patrol_timer.start()

func _on_patrol_timer_timeout() -> void:
	enemy.animation_player.play(GameConstants.ANIM_PATROL)
	
	point_index = wrap(point_index + 1, 0, enemy.path_node.curve.point_count)
	enemy.destination = enemy.get_point_global_position(point_index)
	enemy.navigation_agent.target_position = enemy.destination
