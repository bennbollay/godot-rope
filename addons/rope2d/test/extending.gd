extends Label

func _ready() -> void:
	$Rope2D.create_rope($Target.global_position, 2)
	$Rope2D.extend($Target.global_position, 10)

var gate := NoFasterThan.new()
func _process(delta: float) -> void:
	gate.try(delta, func():
		if not Input.is_action_pressed("ui_accept"):
			return
				
		$Rope2D.extend($Target.global_position, 5)
	)
