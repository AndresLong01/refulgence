extends EnemyState

@export var target_update_timer: Timer

var target: CharacterBody2D

func enter() -> void:
	enemy.enemy_speed = 120.0
	enemy.animation_player.play(GameConstants.ANIM_MOVE)
	enemy.attack_area.connect("body_entered", _on_attack_area_body_entered)
	enemy.chase_area.connect("body_exited", _on_chase_area_body_exited)
	
	target = enemy.chase_area.get_overlapping_bodies()[0]
	target_update_timer.connect("timeout", _handle_timeout)

func physics_update(delta: float) -> void:
	enemy.move(delta)

func exit() -> void:
	enemy.attack_area.disconnect("body_entered", _on_attack_area_body_entered)
	enemy.chase_area.disconnect("body_exited", _on_chase_area_body_exited)
	target_update_timer.disconnect("timeout", _handle_timeout)

func _handle_timeout():
	enemy.destination = target.global_position
	enemy.navigation_agent.target_position = enemy.destination
