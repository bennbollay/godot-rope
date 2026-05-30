@abstract
extends RigidBody2D

## The abstract base class that various different types of [RopePiece] are
## derived from.
class_name RopePiece

## Force added from a [WindArea2D] on this [RopePiece].
var wind_velocity: Vector2 = Vector2(0, 0)
var _location_target: Vector2 = Vector2.INF
var _push_rope: bool = false

## Push this piece towards the current [annotation CanvasItem.get_global_mouse_position].
var follow_mouse: bool = false

## The next [RopePiece] in the [Rope2D].
var next_piece: RopePiece

## Used in [RopeAnchor]-conforming types like [RopeAnchorPinJoint]
## and [RopeAnchorGroovePin].
var piece_parameters: RopePieceParameters

## Used in [RopeAnchor]-conforming types like [RopeAnchorPinJoint]
## and [RopeAnchorGroovePin].
var anchor_parameters: RopeAnchorParameters


signal on_relocation_done()


func _silence_editor_warnings():
	on_relocation_done.get_name()

@abstract func get_start_position() -> Vector2
@abstract func get_angle_to_next() -> float
@abstract func set_shape(shape: CapsuleShape2D, piece_length: float)
@abstract func set_joint_parameters(bias: float, softness: float)
@abstract func get_relocation_path() -> String
@abstract func add_relocation_force(force: Vector2)

func relocate_to(length: float, angle: float, target_anchor: RopePiece, force: float = 50):
	var groove := GrooveJoint2D.new()
	add_child(groove)
	groove.global_position = global_position
	groove.initial_offset = 0
	groove.length = length
	groove.rotate(angle)
	groove.node_a = target_anchor.get_relocation_path()
	groove.node_b = get_relocation_path()

	_location_target = target_anchor.global_position

	if _push_rope:
		add_relocation_force((_location_target - global_position) * force)
	await on_relocation_done

func set_next_piece(next: RopePiece):
	next_piece = next


func clear_next():
	next_piece = null


## Not implemented by default; not used by RopePieces, only Anchors
func create_piece(_mount: Node) -> RopePiece:
	assert(false)
	return null


## Not implemented by default
func clone(_mount: Node) -> RopePiece:
	assert(false)
	return null
