extends Resource

## A collection of parameters used to configure newly created [RopePiece]
## elements.
class_name RopePieceParameters

## Specifies the length of the [RopePiece].
@export var piece_length: float = Rope2D.DEFAULT_PIECE_LENGTH
## Specifies if the [RopePiece] should be pushed out of
## the [annotation Rope2D.spool] versus letting it be
## unspooled as normal physics pull on the rope.
@export var push_rope: bool = false
## Force to use when adding (if [member push_rope] is set to `TRUE`) or
## removing [RopePiece] via [annotation Rope2D.spool].
@export var push_rope_force: float = 50.0

@export_group("RigidBody2D")
## Overloads [annotation RigidBody2D.gravity_scale].
@export var gravity_scale: float = 0.0
## Overloads [annotation RigidBody2D.mass].
@export var mass: float = 1.0
## Overloads [annotation RigidBody2D.freeze].
@export var freeze: bool = false

@export_subgroup("Linear")
## Overloads [annotation RigidBody2D.linear_damp_mode].
@export var linear_damp_mode: RigidBody2D.DampMode = RigidBody2D.DAMP_MODE_COMBINE
## Overloads [annotation RigidBody2D.linear_damp].
@export var linear_damp: float = 0.0

@export_subgroup("Angular")
## Overloads [annotation RigidBody2D.angular_damp_mode].
@export var angular_damp_mode: RigidBody2D.DampMode = RigidBody2D.DAMP_MODE_COMBINE
## Overloads [annotation RigidBody2D.angular_damp].
@export var angular_damp: float = 0.0

@export_group("CollisionObject2D")
## Overloads [annotation CollisionObject2D.collision_layer].[br]
## [br]
## [b]Note:[/b] Do not have the [member collision_layer] and [member collision_mask] overlap.
@export_flags_2d_physics var collision_layer: int = 1:
	set(v):
		collision_layer = v
		validate()

## Overloads [annotation CollisionObject2D.collision_mask].[br]
## [br]
## [b]Note:[/b] Do not have the [member collision_layer] and [member collision_mask] overlap.
@export_flags_2d_physics var collision_mask: int = 0x10:
	set(v):
		collision_mask = v
		validate()

@export_group("Joint")
## Overloads [annotation PinJoint2D.softness].
@export var pin_joint_softness: float = 0.2
## Overloads [annotation PinJoint2D.bias].
@export var pin_joint_bias: float = 0.9
## Specifies the shape of the [CollisionShape2D] used in the [RopePiece].[br]
## [i](Default: [CapsuleShape2D])[/i]
@export var shape: Shape2D = CapsuleShape2D.new()

var _param_list = [
	"piece_length",
	"push_rope",
	"push_rope_force",
	"gravity_scale",
	"mass",
	"freeze",
	"linear_damp_mode",
	"linear_damp",
	"angular_damp_mode",
	"angular_damp",
	"collision_layer",
	"collision_mask",
	"pin_joint_softness",
	"pin_joint_bias",
]


func _init():
	shape.height = piece_length
	shape.radius = 1.0
	validate()


func to_json() -> Dictionary:
	var r: Dictionary = { }

	for p in _param_list:
		r[p] = get(p)

	return r


func validate():
	if collision_layer & collision_mask:
		print_rich("[color=yellow]WARNING: matching collision_layer (%02X) and collision_mask (%02X) on " % [collision_layer, collision_mask], self)


func apply(piece: RopePiece):
	piece.apply_piece_parameters(self)


static func from_json(p: Dictionary) -> RopePieceParameters:
	var r: RopePieceParameters = RopePieceParameters.new()
	# TBD - Support serialiation of the shape

	for k in p:
		r.set(k, p[k])

	return r
