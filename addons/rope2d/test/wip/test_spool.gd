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
