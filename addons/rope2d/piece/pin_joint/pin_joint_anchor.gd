extends RopePiecePinJoint

## A [RopeAnchor] for a [PinJoint2D]-based [RopePiece].  These are suitable for
## most simple rope usage like vines, mostly static cables, and other
## instances where the physics interactions are limited and tolereance around
## length changes and movement are high.[br]
## [br]
## [b]Note:[/b] Recommended to increase
## [constant PhysicsServer2D.SPACE_PARAM_SOLVER_ITERATIONS] or
## [member ProjectSettings.physics/2d/solver/solver_iterations], especially during
## periods of high physics, to avoid degenerate results.  Target solver iteration values
## must be experimentally derived.[br]
## [br]
## However, even with increased iterations, the [RopePiecePinJoint] is not as
## constrained as the [RopePieceGroovePin] implementation.
class_name RopeAnchorPinJoint

@export var rope_piece_parameters: RopePieceParameters = RopePieceParameters.new()
@export var rope_anchor_parameters: RopeAnchorParameters = RopeAnchorParameters.new()


func _ready() -> void:
	super()
	piece_parameters = rope_piece_parameters
	anchor_parameters = rope_anchor_parameters


func create_piece(mount: Node) -> RopePiecePinJoint:
	return RopePiecePinJoint.create(mount, piece_parameters)


func clone(mount: Node) -> RopePiece:
	var anchor: RopePiece = load("uid://bhof88x0fym2i").instantiate()
	mount.add_child(anchor)
	anchor_parameters.apply(anchor)
	return anchor
