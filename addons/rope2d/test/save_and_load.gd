extends Label

const LABEL = "Press [S] to save and [L] to load ([P]hysics %s)"
const LABEL_SAVED = "Press [S] to save and [L] to load ([P]hysics %s) %d ropes"

var save_physics: bool = false
var saved_ropes: Array = []

var gate := NoFasterThan.new()


func update_text(label: String = ""):
	var t: String
	if saved_ropes.size() == 0:
		t = LABEL % ["saved" if save_physics else "unsaved"]
	else:
		t = LABEL_SAVED % ["saved" if save_physics else "unsaved", saved_ropes.size()]

	text = "%s%s" % [t, ": %s" % label if label else ""]


func _ready() -> void:
	update_text()


func get_ropes() -> Array:
	return get_parent().find_children("Rope2D")


func save_ropes():
	saved_ropes = []
	for rope: Rope2D in get_ropes():
		saved_ropes.push_back(rope.to_json(save_physics))


func load_ropes():
	var ropes: Array = get_ropes()
	for rope_idx: int in range(ropes.size()):
		var rope: Rope2D = ropes[rope_idx]
		rope.from_json(saved_ropes[rope_idx])


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			update_text()
			if Input.is_key_pressed(KEY_P):
				save_physics = !save_physics
				update_text()

			if Input.is_key_pressed(KEY_S):
				save_ropes()
				update_text("saved")

			if Input.is_key_pressed(KEY_L) and saved_ropes.size() > 0:
				load_ropes()
				update_text("loaded")
	)
