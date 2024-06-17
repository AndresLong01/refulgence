extends Character
class_name Enemy

# AI Nodes
@export var enemy_speed: float = 60.0
@export var path_node: Path2D
@export var navigation_agent: NavigationAgent2D
@export var disengage_area: Area2D
@export var chase_area: Area2D
@export var attack_area: Area2D

const GRAVITY: float = 9800.0

var destination: Vector2

func _ready() -> void:
	super()
	pass

func get_point_global_position(index: int) -> Vector2:
	return path_node.curve.get_point_position(index) + path_node.global_position

func move(delta: float) -> void:
	navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(destination)
	velocity.x *= enemy_speed
	velocity.y += GRAVITY * delta
	
	flip_sprite()
	move_and_slide()
