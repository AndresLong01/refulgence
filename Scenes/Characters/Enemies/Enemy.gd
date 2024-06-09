extends Character
class_name Enemy

# AI Nodes
@export var enemy_speed: float = 60.0
@export var path_node: Path2D
@export var navigation_agent: NavigationAgent2D

const GRAVITY: float = 1500.0

var destination: Vector2

func _ready() -> void:
	super()
	pass

func get_point_global_position(index: int):
	return path_node.curve.get_point_position(index) + path_node.global_position

func move():
	navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(destination)
	velocity.x *= enemy_speed
	
	flip_sprite()
	move_and_slide()
