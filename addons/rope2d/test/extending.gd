extends Label

func _ready() -> void:
	$Rope2D.create_rope($Target.global_position, 40)
	$Rope2D.extend($Target.global_position, 200)


var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_key_pressed(KEY_ENTER):
				$Rope2D.extend($Target.global_position, 100)
			if Input.is_key_pressed(KEY_SPACE):
				$Rope2D.contract(100)
	)
