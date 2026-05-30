extends Node2D

class Tracker extends Label:
	const ABS_V: float = 1000000.0

	var label: String
	var min_v: float = ABS_V
	var max_v: float = -ABS_V
	
	var update: Callable
	
	static var start_position: Vector2 = Vector2(50, 50)
	const LINE_HEIGHT: float = 50
	
	func _init(label_: String, update_: Callable):
		label = label_
		update = update_
	
	func _ready() -> void:
		global_position = start_position
		start_position.y += LINE_HEIGHT
		add_theme_font_size_override("font_size", 32)


	func _process(_delta: float):
		var v: float = update.call(_delta)
		min_v = min(min_v, v)
		max_v = max(max_v, v)
		text = "%s: [%03.2f, %03.2f]" % [label, min_v, max_v]

var trackers: Array[Tracker] = []

func spool_pinjoint_rope():
	var rope := Rope2D.new($RopePinJointAnchor)
	add_child(rope)
	rope.create_rope($RopePinJointAnchor.global_position + Vector2.DOWN * 2 * rope.piece_length)
	var start_time := Time.get_ticks_msec()
	await rope.spool(49)
	var total_time := (Time.get_ticks_msec() - start_time) / 1000.0

	add_child(Tracker.new("[PJ] Time", func (_d) -> float:
		return total_time
	))
	add_child(Tracker.new("[PJ] Length", func(_delta: float) -> float:
		return rope.calculate_rope_length()
	))
	
func _ready() -> void:
	spool_pinjoint_rope()
