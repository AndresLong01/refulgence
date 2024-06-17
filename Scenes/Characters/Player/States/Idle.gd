extends PlayerState
class_name Idle

@onready var fall: Fall = $"../Fall"
@onready var rest_timer = $RestTimer

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_IDLE)
	rest_timer.start()
	rest_timer.connect("timeout", _on_rest_timer_timeout)

func update(_delta: float) -> void:
	if not player.is_on_floor():
		fall.set_slip_buffer()
		Transitioned.emit("fall")
	
	if player.is_on_floor():
		check_for_jump_input()
	
	check_for_attack_input()
	check_for_backdash_input()

func physics_update(_delta: float) -> void:
	if (player.velocity.x != 0):
		Transitioned.emit("move")

func exit() -> void:
	rest_timer.stop()
	rest_timer.disconnect("timeout", _on_rest_timer_timeout)

func _on_rest_timer_timeout():
	Transitioned.emit("rest")
