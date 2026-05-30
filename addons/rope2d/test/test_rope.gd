extends Node2D

@onready var rope_start_piece := $RopeStartPiece
@onready var rope_end_piece := $RopeEndPiece

var grow_rope: Rope2D
var extend_rope: Rope2D


func _ready() -> void:
	var rope: Rope2D

	# Test fixed on both ends
	rope = Rope2D.new($RopeStartPiece)
	add_child(rope)
	rope.create_rope($RopeEndPiece) # rope_end_piece.global_position)

	# Test fixed on the front and floating on the end
	rope = Rope2D.new($RopeStartPiece2)
	add_child(rope)
	rope.create_rope($RopeEndPiece2.global_position)

	# Test creating a specific length
	rope = Rope2D.new($RopeStartPiece3)
	add_child(rope)
	var p: Vector2 = ($RopeEndPiece2.global_position - $RopeStartPiece3.global_position).normalized()
	rope.create_rope($RopeStartPiece3.global_position + p * 200)

	# Test growing
	grow_rope = Rope2D.new($RopeStartPiece4)
	add_child(grow_rope)
	grow_rope.create_rope($RopeEndPiece4)

	# Test wind
	rope = Rope2D.new($RopeStartPiece5)
	add_child(rope)
	rope.create_rope($RopeEndPiece5.global_position)
	rope.spool(5)

	# Test extending
	extend_rope = Rope2D.new($RopeStartPiece6)
	add_child(extend_rope)
	extend_rope.create_rope($RopeEndPiece6.global_position, 20)


var gate: float = 0.0
var rope_drawer: RopeDrawSimpleLine


func _process(delta: float) -> void:
	%Mouse.global_position = get_global_mouse_position()
	if gate > 0:
		gate -= delta
	if Input.is_action_pressed("ui_down") and gate <= 0:
		gate = 0.2
		print("Growing rope")
		grow_rope.spool(5)
	if Input.is_action_pressed("ui_left") and grow_rope and not rope_drawer:
		rope_drawer = RopeDrawSimpleLine.new(grow_rope)
		add_child(rope_drawer)
	if Input.is_action_pressed("ui_right") and grow_rope and rope_drawer:
		rope_drawer.queue_free()
		rope_drawer = null
	if Input.is_action_pressed("ui_accept") and extend_rope and gate <= 0:
		gate = 0.2
		extend_rope.extend($RopeEndPiece6.global_position, 5)
