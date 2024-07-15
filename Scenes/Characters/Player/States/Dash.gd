extends PlayerState
class_name Dash

@export var ghost_node: PackedScene
@onready var ghost_timer = $GhostTimer

const DASH_VELOCITY: float = 600.0

func enter():
	player.toggle_horizontal_input(false)
	ghost_timer.start()
	
	var direction = -1 if player.sprite.flip_h else 1
	player.velocity.x = DASH_VELOCITY * direction
	
	player.animation_player.play(GameConstants.ANIM_DASH)
	player.animation_player.connect("animation_finished", _on_animation_finished)

func physics_update(delta: float) -> void:
	player.velocity.y += player.GRAVITY * delta

func exit():
	player.toggle_horizontal_input(true)
	ghost_timer.stop()
	
	player.velocity.x = 0
	player.animation_player.disconnect("animation_finished", _on_animation_finished)

func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(player.sprite.texture, player.position, player.sprite.scale, player.sprite.flip_h)
	get_tree().current_scene.add_child(ghost)

func _on_animation_finished(_animation_name: String) -> void:
	Transitioned.emit("idle")

func _on_ghost_timer_timeout():
	add_ghost()
