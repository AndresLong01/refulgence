extends Node2D
class_name WaterSpring

signal splash

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var reset_modulation_timer = $ResetModulationTimer

var velocity: float = 0.0
var force: float = 0.0
var height: float = 0.0
var target_height: float = 0.0
var index: int = 0
var motion_factor: float = 0.004

var most_recent_collision_body: Node2D

func initialize(x: int, id: int) -> void:
	index = id
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x

func water_update(spring_constant: float, loss_constant: float) -> void:
	height = position.y
	var extension: float = height - target_height
	var friction_loss: float = -loss_constant * velocity
	
	#Hooke's law
	force = -spring_constant * extension + friction_loss
	
	velocity += force
	position.y += velocity

func set_collision_width(value: int) -> void:
	var size: Vector2 = collision_shape_2d.get_shape().size
	var new_size: Vector2 = Vector2(value, 2)
	collision_shape_2d.shape.size = new_size
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == most_recent_collision_body:
		return
	
	most_recent_collision_body = body
	reset_modulation_timer.start()
	var speed: float = body.velocity.y * motion_factor
	emit_signal("splash", index, speed)

func _on_reset_modulation_timer_timeout():
	most_recent_collision_body = null
