extends Label

func _ready() -> void:
	$Rope2D.create_rope($Target.global_position, 100)
