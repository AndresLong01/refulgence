extends Camera2D

@export var player: Player

var target_position := Vector2.ZERO

func _ready() -> void:
	make_current()
	offset.y = -40.0

func _physics_process(delta: float) -> void:
	acquire_position()

func acquire_position() -> void:
	if player != null:
		target_position = player.global_position
