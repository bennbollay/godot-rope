extends Line2D

class_name RopeDrawSimpleLine

var rope: Rope


func _init(draw_rope: Rope):
	rope = draw_rope


func _ready() -> void:
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	joint_mode = Line2D.LINE_JOINT_ROUND
	width = 10


func _process(_delta: float) -> void:
	if not rope:
		return

	points = rope.get_points()


func set_rope(draw_rope: Rope):
	rope = draw_rope
