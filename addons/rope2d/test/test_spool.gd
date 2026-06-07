extends Node2D

var rope: Rope2D
func _ready() -> void:
	rope = Rope2D.new($Start)
	add_child(rope)
	rope.create_rope($End)

var gate: float = 0.0
func _process(delta: float) -> void:
	if gate > 0:
		gate -= delta
	if Input.is_key_pressed(KEY_DOWN) and gate <= 0:
		gate = 0.2
		print("Growing rope")
		rope.spool(1)
		# rope.freeze_rope()

# XXX Okay this seems to work - return back to the main
#     tests and see what's going on there.  At the very
#     least, focus on pinjoint and further basic
#     parameterization there to simplify usage.
#
#     It'd be very nice if it'd be possible to specify
#     the anchors and stuff entirely in the inspector
#     so that it can be easily swapped around.
#
#     And then support negative spool() and extend()
#     to reduce the length of ropes.
