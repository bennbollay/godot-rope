extends Label

func _ready() -> void:
	$Rope2D.create_rope($Target.global_position, 2)
	await $Rope2D.spool(10)

var gate := NoFasterThan.new()
func _process(delta: float) -> void:
	gate.try(delta, func():
		if not Input.is_action_pressed("ui_down"):
			return
			
		$Rope2D.spool(5)
	)
