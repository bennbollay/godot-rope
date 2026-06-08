extends Label

var drawers: Array[RopeDrawSimpleLine] = []
func remove_drawers():
	for drawer in drawers:
		drawer.queue_free()
	drawers.clear()

func add_drawers():
	var ropes: Array = get_parent().find_children("Rope2D")
	for rope: Rope2D in ropes:
		var drawer := RopeDrawSimpleLine.new(rope)
		rope.add_child(drawer)
		drawers.push_back(drawer)

var gate := NoFasterThan.new()
func _process(delta: float) -> void:
	gate.try(delta, func():
		if not Input.is_key_pressed(KEY_D):
			return
			
		if drawers.size() > 0:
			remove_drawers()
			return
					
		add_drawers()
	)
