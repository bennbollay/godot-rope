@icon("res://addons/rope2d/icon/link-minimalistic-svgrepo-com.svg")
@abstract
extends Node2D

## The abstract base class that various different types of [RopePiece], such as
## [RopePiecePinJoint], are derived from.
class_name RopePiece

## Force added from a [WindArea2D] on this [RopePiece].
var wind_velocity: Vector2 = Vector2(0, 0)

## Forcefully push this piece onto the rope when unspooling.
var push_rope: bool = false
var push_rope_force: float = 50.0
var _location_target: Vector2 = Vector2.INF

## Push this piece towards the current [method CanvasItem.get_global_mouse_position].
var follow_mouse: bool = false

## The next [RopePiece] in the [Rope2D].
var next_piece: RopePiece

## Defaults used to configure the underlying nodes and joints.
var piece_parameters: RopePieceParameters

## Internal signal used when this piece has been fully added to the [Rope2D].
signal on_relocation_done()


func _silence_editor_warnings():
	on_relocation_done.get_name()


## Get the angle to the next piece.
@abstract func get_angle_to_next() -> float


## Set the shape of the collision shape, as well as the length.
@abstract func set_shape(shape: Shape2D, piece_length: float)


## Update the joint's bias and softness parameters.
@abstract func set_joint_parameters(bias: float, softness: float)


## Set the [member RigidBody2D.linear_velocity] and
## [member RigidBody2D.angular_velocity] on the [RopePiece].
@abstract func set_velocities(linear: Vector2, angular: float)


## Used during spooling to control which part of the [RopePiece] the [GrooveJoint2D]
## attaches to.
@abstract func get_relocation_path() -> String


## Force added to accelerate the unspooling of this piece.
@abstract func add_relocation_force(force: Vector2)


## On creation, apply the parameters specified in [annotation Rope2D.rope_piece_parameters]
## or related anchor specializations.
@abstract func apply_piece_parameters(parameters: RopePieceParameters)


## The global_position the previous RopePiece attaches to.
@abstract func get_prev_position() -> Vector2


## The global_position the next RopePiece starts at.
@abstract func get_next_position() -> Vector2


## Returns the rotation, in radians, of the [RopePiece].
@abstract func get_rotation() -> float


## Return a [Dictionary] of the [member RigidBody2D.linear_velocity] and
## [member RigidBody2D.angular_velocity].
@abstract func get_velocities() -> Dictionary

## Diagnostic flag to add more logging messages.
var debug: bool = true


## Used by [method Rope2D.spool] to relocate a given piece to the current start position.
func relocate_to(length: float, angle: float, target_anchor: RopePiece, force: float = push_rope_force, new_position: Vector2 = target_anchor.get_prev_position()):
	var groove := GrooveJoint2D.new()
	add_child(groove)
	groove.global_position = get_prev_position()
	# node_b (this node) will go from the current position (initial_offset=0)
	# to node_a's position at length distance.
	if length > 0:
		groove.initial_offset = 0
		groove.length = length
	else:
		groove.initial_offset = -length
		groove.length = -length

	groove.rotate(angle)

	# Always set the node_a and node_b as the last step in setting a
	# GrooveJoint2D, otherwise the physics calculations get confused.
	groove.node_a = target_anchor.get_relocation_path()
	# node_b is the piece that "moves", hence the "initial offset" starting
	# at 0.
	groove.node_b = get_relocation_path()

	_location_target = new_position

	if push_rope or length < 0:
		add_relocation_force((_location_target - get_prev_position()) * force)

	await on_relocation_done


## Updates the [RopePiece] to point at the next one in the rope.
func set_next_piece(next: RopePiece):
	next_piece = next


## Remove the references to the next [RopePiece] from this one.
func clear_next():
	next_piece = null


## Update the global position, which may require customization of sub-elements.
func set_piece_position(pos: Vector2):
	global_position = pos


## Rotate the piece so that it's aligned with the rest of the rope on creation.
func set_piece_rotation(rot: float):
	rotation = rot


## Hide the current piece if it's not part of the active rope.
func set_piece_visible(vis: bool):
	visible = vis


## Returns [code]TRUE[/code] if the [RopePiece] is an anchor element.
func is_anchor() -> bool:
	return false
