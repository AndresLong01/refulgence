extends CharacterBody2D

class_name Character

# Stats
@export var stats: Array[StatResource]

#Node Modules
@export var sprite : Sprite2D
@export var animation_player : AnimationPlayer
@export var hurtbox: Area2D
@export var hitbox: Area2D

func _ready() -> void:
	hurtbox.connect('area_entered', _on_hurtbox_hit)

func flip_sprite() -> void:
	if velocity.x == 0:
		return
	
	var isMovingLeft: bool = velocity.x < 0
	sprite.flip_h = isMovingLeft

func _on_hurtbox_hit(area: Area2D) -> void:
	var health: StatResource = get_stat_resource(StatResource.Stat.Health)
	var player: Character = area.owner
	
	health.stat_value -= player.get_stat_resource(StatResource.Stat.Strength).stat_value

func get_stat_resource(stat: StatResource.Stat) -> StatResource:
	var result: StatResource = null;
	
	for  element: StatResource in stats:
		if element.stat_type == stat:
			result = element
	
	return result
