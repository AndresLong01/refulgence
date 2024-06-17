extends Resource
class_name StatResource

enum Stat {
	Health,
	Strength
}

@export var stat_type: Stat
@export var stat_value: float: set = _set_value, get = _get_value

var on_zero: Callable

func _set_value(new_value: float):
	stat_value = clamp(new_value, 0, INF)
	
	if stat_value == 0:
		if not on_zero:
			return
		
		on_zero.call()

func _get_value():
	return stat_value
