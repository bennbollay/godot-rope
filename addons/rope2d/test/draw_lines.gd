extends Label

var drawers: Array[RopeDrawSimpleLine] = []


func remove_drawers():
	for drawer in drawers:
		drawer.queue_free()
	drawers.clear()

	get_tree().debug_collisions_hint = true
	get_tree().root.propagate_call("queue_redraw")


func get_ropes() -> Array:
	return get_parent().find_children("Rope2D")


func add_drawers():
	for rope: Rope2D in get_ropes():
		var drawer := RopeDrawSimpleLine.new(rope)
		rope.add_child(drawer)
		drawers.push_back(drawer)

	get_tree().debug_collisions_hint = false
	get_tree().root.propagate_call("queue_redraw")


var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_key_pressed(KEY_D):
				if drawers.size() > 0:
					remove_drawers()
					return

				add_drawers()
	)
