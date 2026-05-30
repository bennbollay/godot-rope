extends Resource

## A collection of parameters used to configure newly created [RopePiece]
## elements.
class_name RopePieceParameters


## Overloads the [annotation RigidBody2D.gravity_scale].
@export var gravity_scale: float = 0.0
## Overloads the [annotation RigidBody2D.mass].
@export var mass: float = 1.0
## Specifies if the [RopePiece] should be pushed out of
## the [annotation Rope2D.spool] versus letting it be
## unspooled as normal physics pull on the rope.
@export var push_rope: bool = false
## Overloads the [annotation PinJoint2D.softness].
@export var pin_joint_softness: float = 0.2
## Overloads the [annotation PinJoint2D.bias].
@export var pin_joint_bias: float = 0.9

## Specifies the shape of the [CollisionShape2D] used in the [RopePiece].[br]
## [i](Default: [CapsuleShape2D])[/i]
@export var shape: Shape2D = CapsuleShape2D.new()
## Specifies the length of the [RopePiece].
@export var piece_length: float = Rope2D.DEFAULT_PIECE_LENGTH


func _init(shape_: CapsuleShape2D = null, piece_length_: float = Rope2D.DEFAULT_PIECE_LENGTH, gravity_scale_: float = 0.0, mass_: float = 1.0, push_rope_: bool = false, pin_joint_softness_: float = 0.2, pin_joint_bias_: float = 0.9):
	shape = shape_
	piece_length = piece_length_
	gravity_scale = gravity_scale_
	mass = mass_
	push_rope = push_rope_
	pin_joint_softness = pin_joint_softness_
	pin_joint_bias = pin_joint_bias_

	if not shape:
		shape = CapsuleShape2D.new()
		shape.height = piece_length
		shape.radius = 1.0


func to_json() -> Dictionary:
	return {
		"piece_length": piece_length,
		"gravity_scale": gravity_scale,
		"mass": mass,
		"push_rope": push_rope,
		"pin_joint_softness": pin_joint_softness,
		"pin_joint_bias": pin_joint_bias,
	}


func apply(piece: RopePiece):
	piece.gravity_scale = gravity_scale
	piece.mass = mass
	piece.push_rope = push_rope
	piece.set_joint_parameters(pin_joint_bias, pin_joint_softness)
	piece.set_shape(shape, piece_length)


static func from_json(p: Dictionary) -> RopePieceParameters:
	return RopePieceParameters.new(CapsuleShape2D.new(), Rope2D.DEFAULT_PIECE_LENGTH, p.gravity_scale, p.mass, p.push_rope, p.pin_joint_softness, p.pin_joint_bias)
