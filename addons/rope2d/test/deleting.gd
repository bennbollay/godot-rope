extends Label

var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_key_pressed(KEY_X) and $Rope2D:
				$Rope2D.delete()
	)
