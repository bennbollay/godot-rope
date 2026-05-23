extends Node2D

func _ready() -> void:
	var rope: Rope

	rope = Rope.new($RopeStartPiece, 50, 0.3)
	add_child(rope)
	rope.create_rope($RopeEndPiece)

	var rope_simple_line := RopeDrawSimpleLine.new(rope)
	rope_simple_line.set_color(Color.WEB_GREEN)
	add_child(rope_simple_line)

	rope = Rope.new($RopeStartPiece2, 50, 0.3)
	add_child(rope)
	rope.create_rope($RopeEndPiece2)

	rope_simple_line = RopeDrawSimpleLine.new(rope)
	rope_simple_line.use_gradient()
	rope_simple_line.set_color(Color.BLUE_VIOLET)
	add_child(rope_simple_line)

	rope = Rope.new($RopeStartPiece3, 50)
	add_child(rope)
	var rope_end_piece := rope.create_rope(get_global_mouse_position())
	rope_end_piece.follow_mouse = true
