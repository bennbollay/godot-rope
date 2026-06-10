extends Label

func _ready() -> void:
	$Rope2D.create_rope($Target.global_position, 60)
	await $Rope2D.spool(60)


var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_action_pressed("ui_down"):
				$Rope2D.spool(100)
			if Input.is_action_pressed("ui_up"):
				# Disable the wind so that the RopePieceParameters.push_rope_force doesn't
				# have to fight it when pulling pieces back into the spool.
				$WindArea2D.speed = Vector2.ZERO
				await $Rope2D.spool(-10)
				# Re-enable the wind to add a force extracting pieces out of the spool.
				$WindArea2D.speed = Vector2(2, 0)
	)
