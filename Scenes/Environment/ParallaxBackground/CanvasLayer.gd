extends CanvasLayer

@export var parallax: ParallaxComponent
@export var color_rect: ColorRect

var BG_COLORS: Dictionary = {
	1: "#a0dae8",
	2: "#7693b3",
	3: "#cd90b9",
	4: "#CFFFEC"
}

func _ready() -> void:
	color_rect.color = BG_COLORS[parallax.level_number]
