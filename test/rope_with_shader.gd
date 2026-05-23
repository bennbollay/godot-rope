extends Line2D

class_name TestRopeDrawShader

var rope: Rope

var sh := preload("res://test/rope/test_rope_vfx.gdshader")


func _init(draw_rope: Rope):
	rope = draw_rope
	var shader := ShaderMaterial.new()
	shader.shader = sh


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
