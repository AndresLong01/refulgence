extends EnemyState

func enter() -> void:
	enemy.animation_player.play(GameConstants.ANIM_IDLE)
	enemy.chase_area.connect("body_entered", _on_chase_area_body_entered)
	Transitioned.emit("return")

func update(_delta: float) -> void:
	pass
	#if not enemy.is_on_floor():
		#print('enemy is floating')

func exit() -> void:
	enemy.chase_area.disconnect("body_entered", _on_chase_area_body_entered)
