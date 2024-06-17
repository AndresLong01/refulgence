extends PlayerState
class_name Rest

@onready var fall: Fall = $"../Fall"
@onready var sleep_timer = $SleepTimer

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_START_REST)
	sleep_timer.start()
	player.animation_player.connect("animation_finished", on_start_animation_finished)
	sleep_timer.connect("timeout", _on_sleep_timer_timeout)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		fall.set_slip_buffer()
		Transitioned.emit("fall")
	
	if player.is_on_floor():
		check_for_jump_input()
	
	check_for_attack_input()
	check_for_dash_input()

func physics_update(_delta: float) -> void:
	if (player.velocity.x != 0):
		Transitioned.emit("move")

func exit():
	sleep_timer.stop()
	player.animation_player.disconnect("animation_finished", on_start_animation_finished)
	sleep_timer.disconnect("timeout", _on_sleep_timer_timeout)

func on_start_animation_finished(animation_name: String) -> void:
	if animation_name == GameConstants.ANIM_START_REST:
		player.animation_player.play(GameConstants.ANIM_REST)

func _on_sleep_timer_timeout():
	Transitioned.emit("sleep")
