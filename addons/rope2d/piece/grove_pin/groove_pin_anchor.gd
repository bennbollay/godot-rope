extends RopePieceGroovePin

## A [RopeAnchor] for a [GroveJoint2D]-based [RopePiece].  This alternative design
## is suitable for environments where higher physics accuracy and a more constrained
## length is desired.[br]
## [br]
## [b]Note:[/b] Recommended to increase
## [constant PhysicsServer2D.SPACE_PARAM_SOLVER_ITERATIONS] or
## [member ProjectSettings.physics/2d/solver/solver_iterations], especially during
## periods of high physics, to avoid degenerate results.  Target solver iteration values
## must be experimentally derived.
class_name RopeAnchorGroovePin

@export var rope_piece_parameters: RopePieceParameters = RopePieceParameters.new()
@export var rope_anchor_parameters: RopeAnchorParameters = RopeAnchorParameters.new()

@export_category("RigidBody2D")
@export var mass: float = 1.0
@export var gravity_scale: float = 1.0
@export var freeze: bool = false

func _ready() -> void:
	super()
	piece_parameters = rope_piece_parameters
	anchor_parameters = rope_anchor_parameters
	$Pin.mass = mass
	$Pin.gravity_scale = gravity_scale
	$Pin.freeze = freeze
	#$Groove.freeze = freeze


func create_piece(mount: Node) -> RopePieceGroovePin:
	return RopePieceGroovePin.create(mount, piece_parameters)


func create_anchor(mount: Node) -> RopeAnchor:
	var anchor: RopePiece = load("uid://dmvf0nq7q74ns").instantiate()
	mount.add_child(anchor)
	anchor_parameters.apply(anchor)
	print(anchor, "Applying anchor parameters ", anchor_parameters.gravity_scale)
	return anchor
