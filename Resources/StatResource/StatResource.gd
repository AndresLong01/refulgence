extends Resource
class_name StatResource

enum Stat {
	Health,
	Strength
}

@export var stat_type: Stat

@export var stat_value: float: set = _set_value, get = _get_value

func _set_value(new_value: float):
	stat_value = clamp(new_value, 0, INF)

func _get_value():
	return stat_value
