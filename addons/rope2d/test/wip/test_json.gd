extends Node2D

var saved_rope: Dictionary
var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_key_pressed(KEY_J):
				saved_rope = %Rope2D.to_json()
				print("Saved: ", saved_rope.rope.size())
			if Input.is_key_pressed(KEY_L) and saved_rope:
				print("Loaded: ", saved_rope.rope.size())
				%Rope2D.from_json(saved_rope)
	)
