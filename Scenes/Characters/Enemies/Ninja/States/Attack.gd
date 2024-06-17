extends EnemyState

@onready var attack_cooldown_timer = $AttackCooldownTimer

const HITBOX_DISPLACEMENT: int = 33

func enter() -> void:
	print("Entered attack")
	enemy.animation_player.connect("animation_finished", on_animation_finished)
	attack_cooldown_timer.connect("timeout", _on_cooldown_finished)
	animate_attack()

func exit() -> void:
	print("exiting attack")
	attack_cooldown_timer.stop()
	var hitbox_collider: CollisionShape2D = enemy.hitbox.get_child(0)
	if !hitbox_collider.disabled:
		hitbox_collider.disabled = true
	enemy.animation_player.disconnect("animation_finished", on_animation_finished)
	attack_cooldown_timer.disconnect("timeout", _on_cooldown_finished)

func attack() -> void:
	var new_position: Vector2
	if enemy.sprite.flip_h:
		new_position = Vector2(-HITBOX_DISPLACEMENT, -2)
	else:
		new_position = Vector2(HITBOX_DISPLACEMENT, -2)
	
	enemy.hitbox.position = new_position

func animate_attack() -> void:
	enemy.animation_player.play(GameConstants.ANIM_IDLE)
	attack_cooldown_timer.start()

func on_animation_finished(_animation_name: String) -> void:
	var overlapping_bodies: Array[Node2D] = enemy.attack_area.get_overlapping_bodies()
	var target: Node2D = overlapping_bodies[0] if overlapping_bodies.size() > 0 else null
	
	if not target:
		var disengage_bodies: Array[Node2D] = enemy.disengage_area.get_overlapping_bodies()
		var engaged_target: Node2D = disengage_bodies[0] if disengage_bodies.size() > 0 else null
		if not engaged_target:
			print("player not found returning to patrol")
			Transitioned.emit("return")
			return
		
		print("player in vicinity, chasing")
		Transitioned.emit("chase")
		return
	
	var target_direction: Vector2 = target.global_position - enemy.global_position
	if target_direction.x < 0:
		enemy.sprite.flip_h = true
	else:
		enemy.sprite.flip_h = false
	
	print("player in surroundings, attacking")
	animate_attack()

func _on_cooldown_finished() -> void:
	enemy.animation_player.play(GameConstants.ANIM_ATTACK)
