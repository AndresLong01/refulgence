extends State
class_name EnemyState

@export var enemy: Enemy

func _on_chase_area_body_entered(body):
	Transitioned.emit("chase")

func _on_chase_area_body_exited(body):
	Transitioned.emit("return")

func _on_attack_area_body_entered(body):
	if body is Player:
		Transitioned.emit("attack")
