@abstract
extends Node2D

## The abstract base class that various different types of [RopePiece] are
## derived from.
class_name RopePiece

## Force added from a [WindArea2D] on this [RopePiece].
var wind_velocity: Vector2 = Vector2(0, 0)
var _location_target: Vector2 = Vector2.INF

## Forcefully push this piece onto the rope when unspooling.
var push_rope: bool = false

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

@abstract func get_angle_to_next() -> float
@abstract func set_shape(shape: CapsuleShape2D, piece_length: float)
@abstract func set_joint_parameters(bias: float, softness: float)
@abstract func get_relocation_path() -> String
@abstract func add_relocation_force(force: Vector2)
@abstract func apply_piece_parameters(parameters: RopePieceParameters)
@abstract func apply_anchor_parameters(parameters: RopeAnchorParameters)
## The global_position the previous RopePiece attaches to.
@abstract func get_prev_position() -> Vector2
## The global_position the next RopePiece starts at.
@abstract func get_next_position() -> Vector2

func relocate_to(length: float, angle: float, target_anchor: RopePiece, force: float = 50):
	print(self, ": global_position ", global_position)
	var groove := GrooveJoint2D.new()
	add_child(groove)
	groove.global_position = get_prev_position()
	# node_b (this node) will go from the current position (initial_offset=0)
	# to node_a's position at length distance.
	groove.initial_offset = 0
	groove.length = length

	print("Groove joint:")
	print("  global_position: ", groove.global_position)
	print("  initial_offset : ", groove.initial_offset)
	print("  length         : ", groove.length)
	print("  rotation       : ", rad_to_deg(angle))


	groove.rotate(angle)
	
	# Always set the node_a and node_b as the last step in setting a
	# GrooveJoint2D, otherwise the physics calculations get confused.
	groove.node_a = target_anchor.get_relocation_path()
	# node_b is the piece that "moves", hence the "initial offset" starting
	# at 0.
	groove.node_b = get_relocation_path()

	print("  node_a         : ", groove.node_a)
	print("  node_b         : ", groove.node_b)

	_location_target = target_anchor.get_prev_position()
	print("  location_target: ", _location_target)

	# XXX NEXT:
	#
	# Log the parameters and locations between
	# the old location and the new location so
	# that the code change becomes more obvious.
	if push_rope:
		# XXX get_start_position might be wrong here
		add_relocation_force((_location_target - get_prev_position()) * force)
	await on_relocation_done

func set_next_piece(next: RopePiece):
	next_piece = next


func clear_next():
	next_piece = null

func set_piece_position(pos: Vector2):
	global_position = pos

func set_piece_rotation(rot: float):
	rotation = rot

func set_piece_visible(vis: bool):
	visible = vis
