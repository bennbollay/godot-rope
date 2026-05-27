@abstract
extends RigidBody2D

class_name RopePiece

const LOCATION_TOLERANCE := 4.0

var wind_velocity: Vector2 = Vector2(0, 0)
var location_target: Vector2 = Vector2.INF
var push_rope: bool = false
var follow_mouse: bool = false

var next_piece: RopePiece

signal on_relocation_done()
func _silence_editor_warnings():
	on_relocation_done.get_name()

@abstract func get_start_position() -> Vector2

func set_next_piece(next: RopePiece):
	next_piece = next

func clear_next():
	next_piece = null
	
@abstract func get_angle_to_next() -> float
