extends State
class_name EnemyState

@export var enemy: Enemy

func _ready() -> void:
	if enemy:
		enemy.get_stat_resource(StatResource.Stat.Health).on_zero = Callable(self, "_handle_zero_health")

func _on_chase_area_body_entered(_body):
	Transitioned.emit("chase")

func _on_disengage_area_body_exited(_body):
	Transitioned.emit("return")

func _on_attack_area_body_entered(body):
	if body is Player:
		Transitioned.emit("attack")

func _handle_zero_health():
	Transitioned.emit("death")
