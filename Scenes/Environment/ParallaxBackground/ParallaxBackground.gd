extends ParallaxBackground

class_name ParallaxComponent

const BG_THEMES: Dictionary = {
	1: [
		preload("res://Assets/Environment/Backgrounds/Forest/background_layer_1.png"),
		preload("res://Assets/Environment/Backgrounds/Forest/background_layer_2.png"),
		preload("res://Assets/Environment/Backgrounds/Forest/background_layer_3.png"),
	]
}

@export var level_number: int
@export var mirror_x: float = 960.0
@export var sprite_offset: Vector2 = Vector2(160,-75.0)
@export var sprite_scale: Vector2 = Vector2(3, 3)

func _ready() -> void:
	add_backgrounds()

func get_increment() -> float:
	var backgrounds: Array = BG_THEMES[level_number]
	
	if backgrounds is Array:
		return 1.0 / backgrounds.size()
	else:
		print("Error: Expected Array and got something else.")
		return 0.0

func get_sprite(texture_input: Texture2D) -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = texture_input
	sprite.scale = sprite_scale
	sprite.offset = sprite_offset
	return sprite

func add_layer(texture_input: Texture2D, time_offset: float) -> void:
	var sprite: Sprite2D = get_sprite(texture_input)
	
	var new_layer: ParallaxLayer = ParallaxLayer.new()
	new_layer.motion_mirroring = Vector2(mirror_x, 0)
	new_layer.motion_scale = Vector2(time_offset, 1)
	new_layer.add_child(sprite)
	
	add_child(new_layer)

func add_backgrounds() -> void:
	var increment: float = get_increment()
	var time_offset: float = increment
	var current_bg: Array = BG_THEMES[level_number]
	
	for index in range(current_bg.size()):
		var current_file:Texture2D  = current_bg[index]
		if index == 0:
			add_layer(current_file, 1)
		else:
			add_layer(current_file, time_offset)
			time_offset += increment
