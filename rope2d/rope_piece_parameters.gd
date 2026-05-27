extends Resource
class_name RopePieceParameters

@export var gravity_scale: float = 0.0
@export var mass: float = 1.0
@export var push_rope: bool = false
@export var pin_joint_softness: float = 0.2
@export var pin_joint_bias: float = 0.9

@export var shape: CapsuleShape2D = CapsuleShape2D.new()
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
