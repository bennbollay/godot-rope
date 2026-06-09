extends RefCounted

class_name NoFasterThan

var _max_rate: float = 0.2
var _gate: float = 0


func _init(max_rate = _max_rate) -> void:
	_max_rate = max_rate


func try(delta: float, f: Callable):
	_gate -= delta
	if _gate > 0:
		return
	_gate = _max_rate
	f.call()
