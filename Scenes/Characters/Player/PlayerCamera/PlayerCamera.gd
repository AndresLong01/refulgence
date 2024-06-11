extends Camera2D

@export var player: Player

const MIN_ZOOM: float = 1.75

var target_position := Vector2.ZERO

func _ready() -> void:
	make_current()
	offset.y = -40.0
	zoom = Vector2(MIN_ZOOM, MIN_ZOOM)

func _physics_process(delta: float) -> void:
	# Positioning Camera on Player Global Position
	acquire_position()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10))

func acquire_position() -> void:
	if player != null:
		target_position = player.global_position
