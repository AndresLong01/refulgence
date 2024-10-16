extends Sprite2D

func _ready() -> void:
	ghosting()

func set_property(sprite: Sprite2D, tx_pos: Vector2, tx_scale: Vector2, needs_direction_change: bool) -> void:
	texture = sprite.texture
	hframes = sprite.hframes
	vframes = sprite.vframes
	frame_coords = sprite.frame_coords
	position = tx_pos
	scale = tx_scale
	flip_h = needs_direction_change

func ghosting() -> void:
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.6)
	await tween_fade.finished
	
	queue_free()
